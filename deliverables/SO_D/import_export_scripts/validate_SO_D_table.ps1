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
    $survey_year
)

function ExecuteStoredProcedure {
    $sqlconn = New-Object System.Data.SqlClient.SqlConnection
    $sqlconn.ConnectionString = "Data Source=" + $server + ";Initial Catalog=" + $database + ";Integrated Security=true"
    $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
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

    $p_error_code = New-Object System.Data.SqlClient.SqlParameter
    $p_error_code.ParameterName = "@Error_Code"
    $p_error_code.Direction = [System.Data.ParameterDirection]'Output'
    $p_error_code.DbType = [System.Data.DbType]::Int32
    $sqlcmd.Parameters.Add($p_error_code) >> $null

    try {
        $sqlconn.Open()
        $retval = $sqlcmd.ExecuteNonQuery()
        Write-Host "Query retval: " $retval
        Write-Host "Number of error records: " $p_num_recs.Value
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

    Try {
        Write-Host "survey_year = " $survey_year
        ExecuteStoredProcedure($null)
    } catch {
        "ERROR: $($_.Exception.Message)" | Out-Default
        Write-Error ($_.Exception | Format-List -Force | Out-String) -ErrorAction Continue
        Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue
    }

