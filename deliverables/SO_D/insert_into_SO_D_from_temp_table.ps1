[CmdletBinding(SupportsShouldProcess)]
param (
    # Set the working directory folder that contains the CSV files:
    [Parameter(Mandatory)]
    [String]
    $Folder,

    # Set the allowable file extensions (only CSV) - currently Optional:
    [Parameter(Mandatory)]
    [string]
    $Filter,

    # SQL Server connection info:
    [Parameter(Mandatory=$true)]
    [string]
    $server,

    [Parameter(Mandatory=$true)]
    [string]
    $database,

    [Parameter(Mandatory)]
    [string]
    $protocol
)

function ExecuteStoredProcedure {
    $sqlconn = New-Object System.Data.SqlClient.SqlConnection
    $sqlconn.ConnectionString = "Data Source=" + $server + ";Initial Catalog=" + $database + ";Integrated Security=true"
    $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
    $sqlcmd.CommandType = 'StoredProcedure'
    $sqlcmd.Connection = $sqlconn
    $sqlcmd.CommandTimeout = 0
    $sqlcmd.CommandText = "SO.sp_insert_into_SO_D_from_temp_table"

    # Configure parameters:
    $p_counted_date = New-Object System.Data.SqlClient.SqlParameter
    $p_counted_date.ParameterName = "@Counted_Date"
    $p_counted_date.Direction = [System.Data.ParameterDirection]'Input'
    $p_counted_date.DbType = [System.Data.DbType]'datetime'
    #$p_counted_date = $sqlcmd.Parameters.Add('@Counted_Date',[datetime])
    #$p_counted_date.ParameterDirection.Input
    $p_counted_date.Value = $counted_date
    $sqlcmd.Parameters.Add($p_counted_date) >> $null

    # $p_protocol = $sqlcmd.Parameters.Add('@Protocol',[string])
    # $p_protocol.ParameterDirection.Input
    $p_protocol = New-Object System.Data.SqlClient.SqlParameter
    $p_protocol.ParameterName = "@Protocol"
    $p_protocol.Direction = [System.Data.ParameterDirection]'Input'
    $p_protocol.DbType = [System.Data.DbType]'string'
    $p_protocol.Value = $protocol
    $sqlcmd.Parameters.Add($p_protocol) >> $null

    # $p_survey_type = $sqlcmd.Parameters.Add('@Survey_Type',[string])
    # $p_survey_type.ParameterDirection.Input
    $p_survey_type = New-Object System.Data.SqlClient.SqlParameter
    $p_survey_type.ParameterName = "@Survey_Type"
    $p_survey_type.Direction = [System.Data.ParameterDirection]'Input'
    $p_survey_type.DbType = [System.Data.DbType]'string'
    $p_survey_type.Value = $survey_type
    $sqlcmd.Parameters.Add($p_survey_type) >> $null

    # $p_survey_year = $sqlcmd.Parameters.Add('@Survey_Year',[int])
    # $p_survey_year.ParameterDirection.Input
    $p_survey_year = New-Object System.Data.SqlClient.SqlParameter
    $p_survey_year.ParameterName = "@Survey_Year"
    $p_survey_year.Direction = [System.Data.ParameterDirection]'Input'
    $p_survey_year.DbType = [System.Data.DbType]::Int32
    $p_survey_year.Value = [int]$survey_year
    $sqlcmd.Parameters.Add($p_survey_year) >> $null

    $p_num_recs = New-Object System.Data.SqlClient.SqlParameter
    $p_num_recs.ParameterName = "@Num_Recs"
    $p_num_recs.Direction = [System.Data.ParameterDirection]'Output'
    $p_num_recs.DbType = [System.Data.DbType]::Int32
    $sqlcmd.Parameters.Add($p_num_recs) >> $null
    #$p_num_recs.ParameterDirection.Output

    $p_error_code = New-Object System.Data.SqlClient.SqlParameter
    $p_error_code.ParameterName = "@Error_Code"
    $p_error_code.Direction = [System.Data.ParameterDirection]'Output'
    $p_error_code.DbType = [System.Data.DbType]::Int32
    $sqlcmd.Parameters.Add($p_error_code) >> $null

    try {
        $sqlconn.Open()
        $retval = $sqlcmd.ExecuteNonQuery()
        Write-Host "Query retval: " $retval
        Write-Host "Num recs: " $p_num_recs.Value
        if ($retval -eq -1) {
            Write-Host "Proc error code: $($p_error_code.Value)"
        }

    }
    catch [Exception] {
        Write-Error "Proc error code: $($p_error_code.Value)"
        Write-Error $_.Exception.Message
        Write-Error ($_.Exception | Format-List -Force | Out-String) -ErrorAction Continue
        Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue
    }
    finally {
        $sqlconn.Close()
    }
}

# Create the Get-ChildItem parameters:
$fileSearchParams = @{
    Path = $Folder
    File = $true
    Filter = $Filter
}

#if ($Filter) { $fileSearchParams += @{Include = $Filter}}
#$fileSearchParams += @{Include = $Filter}

# Load the files into a collection:
$fileCollection = Get-ChildItem @fileSearchParams
#$fileCollection = Get-ChildItem -Path $Folder -File

Write-Host "Folder = " $Folder
Write-Host "File collection count = " $fileCollection.Count

foreach ($file in $fileCollection) {
    Try {
        $filename = $file.Name
        $counted_date = $file.CreationTime
        # Extract the year and survey type from the filename:
        #$survey_year = $filename.Substring(5,4).ToInt32($null) # getting "A positional parameter cannot be found that accepts argument 'System.Int32'."
        $survey_year = $filename.Substring(5,4)
        $survey_type = $filename.Substring(14,1).ToUpper()

        Write-Host "filename = " $filename
        Write-Host "counted_date = " $counted_date
        Write-Host "protocol = " $protocol
        Write-Host "survey_type = " $survey_type
        Write-Host "survey_year = " $survey_year
        #ExecuteStoredProcedure($counted_date, $protocol, $survey_type, $survey_year)
        ExecuteStoredProcedure($null)
    } catch {
        "ERROR: $($_.Exception.Message)" | Out-Default
        Write-Error ($_.Exception | Format-List -Force | Out-String) -ErrorAction Continue
        Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue
    }
}

