[CmdletBinding(SupportsShouldProcess)]
param (
    # Set the working directory folder that contains the CSV files:
    [Parameter(Mandatory)]
    [String]
    $Config_file_dir
)

# Variables
# Read the config file (it must be located in the same directory as this script, at least, for this first iteration):
$config_file = "$($Config_file_dir)\load_SO_CSVs_into_temp_table_config.csv"
$config_delimiter = ","
try {
    $sr = New-Object System.IO.StreamReader $config_file
    $config_file = @{} # dictionary/hash table
    
    # Read in the data, line by line
    while ($null -ne ($line = $sr.ReadLine()))  {
        $line_values = $line.Split($config_delimiter)
        $config_file[$line_values[0]] = $line_values[1]
    } 
}
catch {
    Write-Host "ERROR attempting to parse the config file:"
    Write-Host $_
    exit 1
}

$CSV_files = Get-ChildItem -Path $config_file.csv_dir -Filter "SO_D_*_?.csv" -File # expects format SO_D_<yyyyMMdd>_<T>.csv where <T> = survey_type letter
$server_name = $config_file.server_name
$database_name = $config_file.database_name
$sproc_name = $config_file.sproc_name
$ssis_folder = $config_file.ssis_folder
$ssis_project = $config_file.ssis_project
$ssis_package = $config_file.ssis_package

# created ( 1 ), running ( 2 ), canceled ( 3 ), failed ( 4 ), pending ( 5 ), ended unexpectedly ( 6 ), succeeded ( 7 ), stopping ( 8 ), completed ( 9 )
$sproc_retvals = @{
    "created"=1;
    "running"=2;
    "canceled"=3;
    "failed"=4;
    "pending"=5;
    "ended unexpectedly"=6;
    "succeeded"=7;
    "stopping"=8;
    "completed"=9;
}
<#
$sproc_retvals = @{
    1="created";
    2="running";
    3="canceled";
    4="failed";
    5="pending";
    6="ended unexpectedly";
    7="succeeded";
    8="stopping";
    9="completed";
}
#>

$retval = -999
$sproc_timer = 10 #seconds

try {
    # Declare connection to the server and declare command
    $sqlConnectionString = "Data Source=$($server_name);Initial Catalog=$($database_name);Integrated Security=SSPI;"
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString
    $cmd = New-Object System.Data.SqlClient.SqlCommand

    # Add the parameters without setting the values outside the loop. Set the values inside the loop.
    Write-Host "Adding parameters to the sproc input..."
    $p_csv_file = $cmd.Parameters.Add('@CSV_FILE_NAME',[string])
    $p_csv_file.ParameterDirection.Input
    $p_server = $cmd.Parameters.Add('@SERVER_NAME',[string])
    $p_server.ParameterDirection.Input
    $p_db = $cmd.Parameters.Add('@DATABASE_NAME',[string])
    $p_db.ParameterDirection.Input
    $p_ssis_folder = $cmd.Parameters.Add('@FOLDER_NAME',[string])
    $p_ssis_folder.ParameterDirection.Input
    $p_ssis_project = $cmd.Parameters.Add('@PROJECT_NAME',[string])
    $p_ssis_project.ParameterDirection.Input
    $p_ssis_package = $cmd.Parameters.Add('@PACKAGE_NAME',[string])
    $p_ssis_package.ParameterDirection.Input

    # This should also be added outside the loop, but need to test...
    $p_exid = New-Object System.Data.SqlClient.SqlParameter
    $p_exid.ParameterName = "@EXECUTION_ID"
    $p_exid.Direction = [System.Data.ParameterDirection]'Output'
    $p_exid.DbType = [System.Data.DbType]::Int64
    $cmd.Parameters.Add($p_exid) >> $null

    foreach($CSV_file in $CSV_files) {
        Write-Host "Processing file '$($CSV_file.Name)..."

        $cmd.Connection = $sqlConnection
        $cmd.CommandType = 'StoredProcedure'
        $cmd.CommandText = $sproc_name

        Write-Host "Setting parameters to the sproc input..."
        $p_csv_file.Value = $CSV_file.FullName
        $p_server.Value = $server_name
        $p_db.Value = $database_name
        $p_ssis_folder.Value = $ssis_folder
        $p_ssis_project.Value = $ssis_project
        $p_ssis_package.Value = $ssis_package

#        $p_exid = New-Object System.Data.SqlClient.SqlParameter
#        $p_exid.ParameterName = "@EXECUTION_ID"
#        $p_exid.Direction = [System.Data.ParameterDirection]'Output'
#        $p_exid.DbType = [System.Data.DbType]::Int64
#        $cmd.Parameters.Add($p_exid) >> $null

        # Either move this outside the loop to keep it open, or close it each time, or add a condition
        if ($cmd.Connection.State -eq [System.Data.ConnectionState]::Closed) {
            $sqlConnection.Open()
        }
        # we could do an elseif -ne Open then error, or wait?

        if ($cmd.Connection.State -ne [System.Data.ConnectionState]::Open) {
            Write-Error "Failed to open the SqlConnection...quitting..."
            return
        }

        Write-Host "Calling ExecuteNonQuery (sproc)..."
        $cmd.ExecuteNonQuery() | Out-Null

        # Experience has shown the process never finishes before the next loop so let's pause the script briefly:
        Start-Sleep -Seconds $sproc_timer

        $execution_id = $p_exid.Value
        Write-Host "sproc EXECUTION_ID value = $($execution_id)"
        $retval = $execution_id
        
        # We need a loop that is checking the status of the stored procedure.
        # We must not call it for the next CSV until the previous one is finished.
        Write-Host "Setting SqlCommand to read the sproc results..."
        #$cmd_result = New-Object System.Data.SqlClient.SqlCommand($sqlConnection)
        #$cmd_result = $sqlConnection.CreateCommand()
        $cmd.CommandType = 'Text'
        $sql = "SELECT [start_time],[end_time],[status] FROM [SSISDB].[catalog].[executions] WHERE [execution_id]=$($execution_id)"
        Write-Host "sql = $($sql)"
        $cmd.CommandText = $sql
        $is_sproc_success = $false

        while ($is_sproc_success -eq $false) {
            try {
                $results = $cmd.ExecuteReader()

                while ($results.Read()) {
                    $results_hash = @{}
                    $results_hash.Add('start_time', $results.GetValue(0).ToString())
                    $results_hash.Add('end_time', $results.GetValue(1).ToString())
                    $results_hash.Add('status', $results.GetValue(2).ToString())

                    Write-Host 'start_time = '$results_hash['start_time']
                    Write-Host 'end_time   = '$results_hash['end_time']
                    # The possible status codes/meanings:
                    # created ( 1 ), running ( 2 ), canceled ( 3 ), failed ( 4 ), pending ( 5 ), ended unexpectedly ( 6 ), succeeded ( 7 ), stopping ( 8 ), completed ( 9 )
                    Write-Host 'status     = '$results_hash['status']

                    $err_vals = @($sproc_retvals["canceled"],$sproc_retvals["failed"],$sproc_retvals["ended unexpectedly"],$sproc_retvals["created"],$sproc_retvals["stopping"])

                    if ($results_hash['status'] -eq $sproc_retvals['succeeded']) {
                        Write-Host "'$($sproc_name) succeeded for file '$($CSV_file.Name)...continuing to next file..."
                        $is_sproc_success = $true
                    } elseif ($results_hash['status'] -in @(2,5)) {
                        Write-Host "sproc not finished...checking again in $($sproc_timer) seconds..."
                        Start-Sleep -Seconds $sproc_timer
                    } elseif ($results_hash['status'] -in $err_vals) {
                    
                        Write-Host "Stored procedure status is not good!"

                        if ($results_hash['status'] -eq $sproc_retvals["canceled"]) {
                            $status_msg = "sproc status = 'canceled'"
                            throw $status_msg
                        } elseif ($results_hash['status'] -eq $sproc_retvals["failed"]) {       
                            $status_msg = "sproc status = 'failed'"
                            throw $status_msg
                        } elseif ($results_hash['status'] -eq $sproc_retvals["ended unexpectedly"]) {       
                            $status_msg = "sproc status = 'ended unexpectedly'"
                            throw $status_msg
                        }
                    } elseif ($results_hash['status'] -eq $sproc_retvals['completed']) {
                        Write-Host "Status of completed is unusual...expecting 'succeeded'...continuing on to next file but be warned to check this!"
                        $is_sproc_success = $true
                    }
                } # end while reading DataReader
            } catch [Exception] {
                throw $_.Exception.Message
            } finally {
                # Close the DataReader
                $results.Close()
            }
        } # end outer while
        #$dt = New-Object System.Data.DataTable
        #$dt.Load($results)
    } # end foreach

    #$retval = 0

} catch [Exception] {
    Write-Host "ERROR while processing file '$($CSV_file.Name)':"
    Write-Host $_.Exception.Message
    #Write-Host $_.Exception.StackTrace
    Write-Error ($_.Exception | Format-List -Force | Out-String) -ErrorAction Continue
    Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue

} finally {
    if ($cmd.Connection.State -ne [System.Data.ConnectionState]::Closed) {
        $sqlConnection.Close()
    }
    Write-Host "'load_SO_CSVs_into_temp_table' finished with result: " $retval
} # end finally   

 
