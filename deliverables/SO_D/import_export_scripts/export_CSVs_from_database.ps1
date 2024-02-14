<# Export data from database into CSV files.

We have one SQL query, which selects all records from the view. The DB record columns are omitted.
We can pass in the year and the survey type to filter for the export.

UPDATES:

TZ 1/18/2024: 
- Added mechanism to loop through the possible survey type to export the CSV all at once.
- Added TRANSECT to the list of exported fields

TZ 2/13/2024:
- Changed the export mechanism from BCP (which doesn't easily support sorting) to a SQLDataReader/StreamWriter (.NET).
- Modified the SQL query, no longer need the UNION for column headings, and adjusted the string syntax as needed.

#>

# Script input parameters:
[CmdletBinding(SupportsShouldProcess)]
param (
    # Set the working directory folder. The exports will go to a subdir on the server:
    [Parameter(Mandatory)]
    [String]
    $Output_folder,

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

# This function is deprecated. Remove later once confirmed we won't use it. It is faster but not easy to sort.
function ExportCSV_BCP([string]$survey_type, [int]$survey_year, [string]$outputFilename) {
        
    Write-Host "In ExportCSV_BCP..."
    Write-Host "`$survey_type = $survey_type"
    Write-Host "`$survey_year = $survey_year"
    Write-Host "`$outputFilename = $outputFilename"
    Write-Host " "

    # Sorting does not work.
    # What if we write the sorted data to a temp table, and then union from that? I think, if possible, the temp table needs to be sorted by a clustered index key. 
    # If that is possible, then use bcp hint -h ORDER (column [ASC]) syntax
    # Or, try doing the CSV export some other way...see Bill's code in the DM stuff.
    # Or, can just create a DataReader and then write all the columns to the file manually. Slower and more painful to code but not terrible.
#    $query = "SELECT 'PHOTO_FILE_NAME' AS PHOTO_FILE_NAME,'PHOTO_TIMESTAMP_UTC','PHOTO_TIMESTAMP_AK_Local' AS PHOTO_TIMESTAMP_AK_Local,'LATITUDE_WGS84','LONGITUDE_WGS84','ALTITUDE','SURVEY_TYPE','COUNT_ADULT','COUNT_PUP','KELP_PRESENT','LAND_PRESENT','IMAGE_QUALITY','COUNTED_BY','COUNTED_DATE','PROTOCOL','QUALITY_FLAG','ORIGINAL_FILENAME','FLOWN_BY','CAMERA_SYSTEM','TRANSECT','VALIDATED_BY'
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
    WHERE [SURVEY_TYPE] = '$($survey_type)' AND DATEPART(year, [PHOTO_TIMESTAMP_UTC]) = $($survey_year)
    ORDER BY PHOTO_TIMESTAMP_AK_Local,PHOTO_FILE_NAME ASC;"

    Write-Host "`$query = $query"

    $bcp_cmd = "bcp $($doubleQuoteChar) $($query) $($doubleQuoteChar) queryout $($outputFilename) -t $($delimiter) -d $($database_name) -S $($server_name) -T -c"
    Write-Host "bcp command: $($bcp_cmd)"

    # invoke the command
    Invoke-Expression $bcp_cmd
}

<#
 # Uses a SQLDataReader and a StreamWriter to query the database and write the CSV to file(s).
 #>
function ExportCSV([string]$survey_type, [int]$survey_year, [string]$outputFilename, [System.Data.SqlClient.SqlCommand]$cmd) {
        
    Write-Host "In ExportCSV..."
    Write-Host "`$survey_type = $survey_type"
    Write-Host "`$survey_year = $survey_year"
    Write-Host "`$outputFilename = $outputFilename"
    Write-Host " "

    $query = @"
    SELECT
    [PHOTO_FILE_NAME]
    ,[PHOTO_TIMESTAMP_UTC]
    ,[PHOTO_TIMESTAMP_AK_Local] AS PHOTO_TIMESTAMP_AK_LOCAL
    ,CAST([LATITUDE_WGS84] AS nvarchar) AS LATITUDE_WGS84
    ,CAST([LONGITUDE_WGS84] AS nvarchar) AS LONGITUDE_WGS84
    ,CAST([ALTITUDE] AS nvarchar) AS ALTITUDE
    ,[SURVEY_TYPE]
    ,CAST([COUNT_ADULT] AS nvarchar) AS COUNT_ADULT
    ,CAST([COUNT_PUP] AS nvarchar) AS COUNT_PUP
    ,CASE WHEN [KELP_PRESENT] IS NULL THEN '' ELSE [KELP_PRESENT] END AS KELP_PRESENT
    ,CASE WHEN [LAND_PRESENT] IS NULL THEN '' ELSE [LAND_PRESENT] END AS LAND_PRESENT
    ,CASE WHEN [IMAGE_QUALITY] IS NULL THEN '' ELSE [IMAGE_QUALITY] END AS IMAGE_QUALITY
    ,[COUNTED_BY]
    ,[COUNTED_DATE]
    ,[protocol]
    ,CASE WHEN [QUALITY_FLAG] IS NULL THEN '' ELSE [QUALITY_FLAG] END AS QUALITY_FLAG
    ,CASE WHEN [ORIGINAL_FILENAME] IS NULL THEN '' ELSE [ORIGINAL_FILENAME] END AS ORIGINAL_FILENAME
    ,CASE WHEN [FLOWN_BY] IS NULL THEN '' ELSE [FLOWN_BY] END AS FLOWN_BY
    ,CASE WHEN [CAMERA_SYSTEM] IS NULL THEN '' ELSE [CAMERA_SYSTEM] END AS CAMERA_SYSTEM
    ,CASE WHEN [TRANSECT] IS NULL THEN '' ELSE [TRANSECT] END AS TRANSECT
    ,[VALIDATED_BY]
    FROM [SO].[view_SO_D_allrecs_w_lookups]
    WHERE [SURVEY_TYPE] = '$($survey_type)' AND DATEPART(year, [PHOTO_TIMESTAMP_UTC]) = $($survey_year)
    ORDER BY PHOTO_TIMESTAMP_AK_Local,PHOTO_FILE_NAME ASC;
"@
    # For PS multi-line strings (above), the "@ chars on the last line MUST be the first two characters of that line,
    # so don't try to indent them to make it look pretty!

    Write-Host "`$query = $query"

    # Declare connection to the server and declare command
    #$sqlConnectionString = "Data Source=$($server_name);Initial Catalog=$($database_name);Integrated Security=SSPI;"
    #$sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString
    #$cmd = New-Object System.Data.SqlClient.SqlCommand
    $retval = $false

    try {
        $sb = [System.Text.StringBuilder]::new()
        $cmd.CommandType = 'Text'
        $cmd.CommandText = $query

        $dr = $cmd.ExecuteReader()
        $firstLine = $true

        # strip off the enclosing double quotes:
        $temp = $outputFilename.Replace('"','')

        $filePath = [System.IO.Path]::GetDirectoryName($temp)
        $fileName = [System.IO.Path]::GetFileName($temp)
        $newFile = New-Item -Path $filePath -Name $fileName -ItemType File

        # open a writable FileStream
        $fileStream = $newFile.OpenWrite()

        # create stream writer
        $streamWriter = [System.IO.StreamWriter]::new($fileStream)

        while ($dr.Read()) {

            [string]$line = ""

            # Write the column headers
            if ($firstLine -eq $true) {
                for ($i = 0; $i -lt $dr.FieldCount; $i++) {
                    if ($i -lt $dr.FieldCount-1) {
                        [void]$sb.Append($dr.GetName($i))
                        [void]$sb.Append(",")
                    } else {
                        [void]$sb.AppendLine($dr.GetName($i))
                    }
                }
                $firstLine = $false
            }

            for ($col = 0; $col -lt $dr.FieldCount - 1; $col++) {
                if ($dr.IsDBNull($col) -ne $true) {
                    [void]$sb.Append($dr.GetValue($col).ToString())
                }
                [void]$sb.Append(",")
            }

            if ($dr.IsDBNull($dr.FieldCount-1) -ne $true) {
                [void]$sb.Append($dr.GetValue($dr.FieldCount-1).ToString())
            }

            # write to stream
            [void]$streamWriter.WriteLine($sb.ToString())
            $sb.Clear()

        } # end while through reader
        $dr.Close()
        $streamWriter.Close()
        $retval = $true

    } catch [Exception] {
        Write-Host "ERROR in ExportCSV: "
        Write-Host $_.Exception.Message
        Write-Error ($_.Exception | Format-List -Force | Out-String) -ErrorAction Continue
        Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue

    } finally {
        Write-Host "'ExportCSV' finished with result: $($retval)"
    } # end finally   
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
        ExportCSV -survey_type $survey_type -survey_year $survey_year -outputFilename $outputFilename -cmd $sqlcmd
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
