# Use BCP to export data to CSV files.
#
# We have one SQL query, which selects all records from the view. The DB record columns are omitted.
# We can pass in the year and the survey type to filter for the export.
#
# NOTE!!! BCP does NOT have a mechanism to export the column headings!
# Easiest workaround is make a UNION query and select the column headings separately.
#
# UPDATES:
#
# TZ 1/18/2024: 
# - Added mechanism to loop through the possible survey type to export the CSV all at once.
# - Added TRANSECT to the list of exported fields
#

# Script input parameters:
[CmdletBinding(SupportsShouldProcess)]
param (
    # Set the working directory folder. The exports will go to a subdir on the server:
    [Parameter(Mandatory)]
    [String]
    $Output_folder,

    # # Set the allowable file extensions (only CSV) - currently Optional:
    # [Parameter(Mandatory)]
    # [string]
    # $Filter,

    # SQL Server connection info:
    [Parameter(Mandatory=$true)]
    [string]
    $server_name,

    [Parameter(Mandatory=$true)]
    [string]
    $database_name,

    [Parameter(Mandatory=$true)]
    [int]
    $survey_year
)

function GetSurveyDate([string] $survey_type) {

}

function ExportCSV([string]$survey_type, [int]$survey_year, [string]$outputFilename) {
        
    Write-Host "In ExportCSV..."
    Write-Host "`$survey_type = $survey_type"
    Write-Host "`$survey_year = $survey_year"
    Write-Host "`$outputFilename = $outputFilename"
    Write-Host " "

    $query = "SELECT 'PHOTO_FILE_NAME,PHOTO_TIMESTAMP_UTC,PHOTO_TIMESTAMP_AK_Local,LATITUDE_WGS84,LONGITUDE_WGS84,ALTITUDE,SURVEY_TYPE,COUNT_ADULT,COUNT_PUP,KELP_PRESENT,LAND_PRESENT,IMAGE_QUALITY,COUNTED_BY,COUNTED_DATE,PROTOCOL,QUALITY_FLAG,ORIGINAL_FILENAME,FLOWN_BY,CAMERA_SYSTEM,TRANSECT,VALIDATED_BY'
    UNION ALL
    SELECT
    [PHOTO_FILE_NAME] + ',' +
    [PHOTO_TIMESTAMP_UTC] + ',' +
    [PHOTO_TIMESTAMP_AK_Local] + ',' +
    CAST([LATITUDE_WGS84] AS nvarchar) + ',' +
    CAST([LONGITUDE_WGS84] AS nvarchar) + ',' +
    CAST([ALTITUDE] AS nvarchar) + ',' +
    [SURVEY_TYPE] + ',' +
    CAST([COUNT_ADULT] AS nvarchar) + ',' +
    CAST([COUNT_PUP] AS nvarchar) + ',' +
    CASE WHEN [KELP_PRESENT] IS NULL THEN '' ELSE [KELP_PRESENT] END + ',' +
    CASE WHEN [LAND_PRESENT] IS NULL THEN '' ELSE [LAND_PRESENT] END + ',' +
    CASE WHEN [IMAGE_QUALITY] IS NULL THEN '' ELSE [IMAGE_QUALITY] END + ',' +
    [COUNTED_BY] + ',' +
    [COUNTED_DATE] + ',' +
    [protocol] + ',' +
    CASE WHEN [QUALITY_FLAG] IS NULL THEN '' ELSE [QUALITY_FLAG] END + ',' +
    CASE WHEN [ORIGINAL_FILENAME] IS NULL THEN '' ELSE [ORIGINAL_FILENAME] END + ',' +
    CASE WHEN [FLOWN_BY] IS NULL THEN '' ELSE [FLOWN_BY] END + ',' +
    CASE WHEN [CAMERA_SYSTEM] IS NULL THEN '' ELSE [CAMERA_SYSTEM] END + ',' +
    CASE WHEN [TRANSECT] IS NULL THEN '' ELSE [TRANSECT] END + ',' +
    [VALIDATED_BY]
    FROM [SO].[view_SO_D_allrecs_w_lookups]
    WHERE [SURVEY_TYPE] = '$($survey_type)' AND DATEPART(year, [PHOTO_TIMESTAMP_UTC]) = $($survey_year);"

    Write-Host "`$query = $query"

    $bcp_cmd = "bcp $($doubleQuoteChar) $($query) $($doubleQuoteChar) queryout $($outputFilename) -t $($delimiter) -d $($database_name) -S $($server_name) -T -c"
    Write-Host "bcp command: $($bcp_cmd)"

    # invoke the command
    Invoke-Expression $bcp_cmd
}

# special double quote character
$doubleQuoteChar = [char]34
$delimiter = "$($doubleQuoteChar),$($doubleQuoteChar)"
$survey_types = @('Optimal','Abundance','Random')

$sqlconn = New-Object System.Data.SqlClient.SqlConnection
$sqlconn.ConnectionString = "Data Source=" + $server_name + ";Initial Catalog=" + $database_name + ";Integrated Security=true"
$sqlcmd = New-Object System.Data.SqlClient.SqlCommand
$sqlcmd.CommandType = 'Text'
$sqlcmd.Connection = $sqlconn
$sqlcmd.CommandTimeout = 0

try {

    foreach($survey_type in $survey_types) {

        Write-Host "Processing survey type $survey_type..."

        # Need to set the output filename ...
        # This will be a function that gets called 3 times, once for each survey type.
        # Also need to filter by survey year and order ASC to get the first record (though that should not matter).
        $sqlcmd.CommandText = "SELECT TOP 1 PHOTO_TIMESTAMP_AK_Local FROM [SO].[view_SO_D_allrecs_w_lookups] " +
            "WHERE SURVEY_TYPE = '$($survey_type)' " +
            "AND DATEPART(year, [PHOTO_TIMESTAMP_AK_Local]) = $($survey_year) " +
            "ORDER BY [PHOTO_TIMESTAMP_AK_Local];"
        # where the survey_type will need to be the full word
        # and then use the returned date as $survey_date which gets parsed to create the output filename.

        if ($sqlcmd.Connection.State -eq [System.Data.ConnectionState]::Closed) {
            $sqlconn.Open()
        }

        $survey_date = [datetime]$sqlcmd.ExecuteScalar()


        # Build the export filename:
        $outputFilename = "$($doubleQuoteChar)$($Output_folder)\SO_D_$($survey_date.ToString("yyyyMMdd"))_$($survey_type.Substring(0,1).ToUpper()).CSV$($doubleQuoteChar)"

        # Run the export (BCP):
        # Was having trouble passing this conversion value in the function call...
        $survey_year = [Convert]::ToInt32($survey_date.ToString("yyyy"))
        ExportCSV -survey_type $survey_type -survey_year $survey_year -outputFilename $outputFilename
    }

}
catch [Exception] {
    Write-Error $_.Exception.Message
    Write-Error ($_.Exception | Format-List -Force | Out-String) -ErrorAction Continue
    Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue
}
finally {
    if ($sqlcmd.Connection.State -ne [System.Data.ConnectionState]::Closed) {
        $sqlconn.Close()
    }
}
