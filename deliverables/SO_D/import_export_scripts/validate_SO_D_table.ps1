<# 
    .SYNOPSIS
    validate_SO_D_table.ps1

    .DESCRIPTION
    Executes the [SO].[sp_validate_SO_D_table] stored procedure, which validates the data in the SO_D table and writes
    errors to the [SO_D_VALIDATION] table.
    Then export the errors written in SO_D_VALIDATION to a CSV report file.

    .PARAMETER server_name
    Name of the database server.

    .PARAMETER database_name
    Name of the database.

    .PARAMETER survey_year
    Year the survey was conducted. Will be appended to the so_c_base_folder parameter to build the photos archive directory.

    .PARAMETER output_file
    Full path and filename of output CSV error report file. Must be a UNC path to the server, not a local drive.

    .EXAMPLE
    .\validate_SO_D_table.ps1 -server inpglbafs03 -database SEAN_Staging_TEST_2017 -survey_year 2022 -output_filename \\inpglbafs03\data\sean_data\work_zone\SO\SO_D\<survey_year>\exported_files\error_report.csv

#>

<#
    UPDATES:

    TZ 2/22/2024: 
    - Created.

    TZ 3/4/2024:
    - Added error results report, which contains the records from the SO_D_VALIDATION table.

#>

[CmdletBinding(SupportsShouldProcess)]
param (
    # SQL Server connection info:
    [Parameter(Mandatory=$true)]
    [string]
    $server,

    [Parameter(Mandatory=$true)]
    [string]
    $database,

    [Parameter(Mandatory=$true)]
    [int]
    $survey_year,

    [Parameter(Mandatory=$true)]
    [string]
    $output_filename
)

function ExecuteStoredProcedure(
    [System.Data.SqlClient.SqlCommand]$sqlcmd, 
    [System.Data.SqlClient.SqlConnection]$sqlconn, [int]$num_mand_errors, [int]$num_opt_errors) {

    $sqlcmd.CommandType = 'StoredProcedure'
    $sqlcmd.Connection = $sqlconn
    $sqlcmd.CommandTimeout = 0
    $sqlcmd.CommandText = "SO.sp_validate_SO_D_table"

    # Configure parameters:
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

    $p_mand_errs = New-Object System.Data.SqlClient.SqlParameter
    $p_mand_errs.ParameterName = "@Mand_Errors"
    $p_mand_errs.Direction = [System.Data.ParameterDirection]'Output'
    $p_mand_errs.DbType = [System.Data.DbType]::Int32
    $sqlcmd.Parameters.Add($p_mand_errs) >> $null

    $p_opt_errs = New-Object System.Data.SqlClient.SqlParameter
    $p_opt_errs.ParameterName = "@Opt_Errors"
    $p_opt_errs.Direction = [System.Data.ParameterDirection]'Output'
    $p_opt_errs.DbType = [System.Data.DbType]::Int32
    $sqlcmd.Parameters.Add($p_opt_errs) >> $null

    $p_error_code = New-Object System.Data.SqlClient.SqlParameter
    $p_error_code.ParameterName = "@Error_Code"
    $p_error_code.Direction = [System.Data.ParameterDirection]'Output'
    $p_error_code.DbType = [System.Data.DbType]::Int32
    $sqlcmd.Parameters.Add($p_error_code) >> $null

    try {
        $sqlconn.Open()
        $retval = $sqlcmd.ExecuteNonQuery()
        Write-Host "Query retval: " $retval
        $num_mand_errors = $p_mand_errs.Value
        $num_opt_errors = $p_opt_errs.Value
        
        #Write-Host "Number of mandatory errors: $($p_mand_errs.Value)"
        #Write-Host "Number of optional errors: $($p_opt_errs.Value)"
        Write-Host "Number of mandatory errors: $($num_mand_errors)"
        Write-Host "Number of optional errors: $($num_opt_errors)"

        if ($retval -eq -1) {
            Write-Host "Stored procedure error code: $($p_error_code.Value)"
        }

    }
    catch [Exception] {
        Write-Error "Stored proc error code: $($p_error_code.Value)"
        Write-Error $_.Exception.Message
        Write-Error ($_.Exception | Format-List -Force | Out-String) -ErrorAction Continue
        Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue
    }
    finally {
        $sqlconn.Close()
    }
}

$sqlconn = New-Object System.Data.SqlClient.SqlConnection
$sqlconn.ConnectionString = "Data Source=" + $server + ";Initial Catalog=" + $database + ";Integrated Security=true"
$sqlcmd = New-Object System.Data.SqlClient.SqlCommand
$num_mand_errors = 0
$num_opt_errors = 0
# special double quote character
$doubleQuoteChar = [char]34
$delimiter = "$($doubleQuoteChar),$($doubleQuoteChar)"


try {
    Write-Host "survey_year = " $survey_year
    #ExecuteStoredProcedure($null)
    ExecuteStoredProcedure -sqlcmd $sqlcmd -sqlconn $sqlconn -num_mand_errors $num_mand_errors -num_opt_errors $num_opt_errors 

    # Query the SO_D_Validation table, and if it has data, dump to CSV file:
    # Note the UNION is required to write the column headers.
    $query = "SELECT 'ID','PHOTO_FILE_NAME','PHOTO_TIMESTAMP_AK_LOCAL','ERROR_TYPE','ERROR_DETAILS' UNION ALL SELECT CAST(ID AS NVARCHAR(10)),PHOTO_FILE_NAME,CAST(PHOTO_TIMESTAMP_AK_LOCAL AS NVARCHAR(20)),ERROR_TYPE,ERROR_DETAILS FROM [SO].[SO_D_VALIDATION] WHERE DATEPART(year, PHOTO_TIMESTAMP_AK_LOCAL) = $($survey_year);"
    Write-Host "Write errors to report: $($query)"
    $sqlcmd.CommandType = 'Text'
    $sqlcmd.CommandText = $query
    $sqlconn.Open()

    $bcp_cmd = "bcp $($doubleQuoteChar) $($query) $($doubleQuoteChar) queryout $($output_filename) -t $($delimiter) -d $($database) -S $($server) -T -c"
    Write-Host "bcp command: $($bcp_cmd)"

    # invoke the command
    Invoke-Expression $bcp_cmd


} catch {
    "ERROR: $($_.Exception.Message)" | Out-Default
    Write-Error ($_.Exception | Format-List -Force | Out-String) -ErrorAction Continue
    Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue
} finally {
    if ($sqlcmd.Connection.State -ne [System.Data.ConnectionState]::Closed) {
        $sqlconn.Close()
    }
}

