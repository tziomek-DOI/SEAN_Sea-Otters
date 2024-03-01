<# rename_SO_C_filenames.ps1

DESCRIPTION:
The SO_C files (aerial photos) come out of the SeeOtter application with its version of filename formats.
This script renames the photos to match the SEAN SO_C deliverable format.
The SO_D database table has a mapping of the original and expected filenames. We query the database,
and iterate/rename the files.

UPDATES:

TZ 2/29/2024: 
- Created.

#>

# Script input parameters:
[CmdletBinding(SupportsShouldProcess)]
param (
    # There are three subdirs for each survey year of SO_C. The base should be \\inpglbafs03\data\sean_data\work_zone\SO\SO_C\
    # We could just hard-code that...blasphemy!
    [Parameter(Mandatory)]
    [String]
    $so_c_base_folder,

    # SQL Server connection info:
    [Parameter(Mandatory=$true)]
    [string]
    $server_name,

    [Parameter(Mandatory=$true)]
    [string]
    $database_name,

    # Send in the survey year so we DON'T have to hard-code the base folder.
    [Parameter(Mandatory=$true)]
    [int]
    $survey_year
)

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
		SELECT PHOTO_FILE_NAME, PHOTO_TIMESTAMP_UTC, ORIGINAL_FILENAME
		FROM [SO].[SO_D]
		WHERE DATEPART(year, PHOTO_TIMESTAMP_AK_LOCAL) = $($Survey_Year)
		AND SUBSTRING(PHOTO_FILE_NAME, 15, 1) = $($Survey_Type)
		AND ORIGINAL_FILENAME IN (
		'0_000_00_001.jpg',
        '0_000_00_002.jpg',
        '0_000_00_003.jpg',
        '0_000_00_004.jpg',
        '0_000_00_005.jpg',
        '0_000_00_006.jpg',
        '0_000_00_007.jpg',
        '0_000_00_008.jpg',
        '0_000_00_009.jpg',
        '0_000_00_010.jpg',
        '0_000_00_011.jpg',
        '0_000_00_012.jpg'
        );
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
            [void]$sb.Clear()

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
#$doubleQuoteChar = [char]34
#$delimiter = "$($doubleQuoteChar),$($doubleQuoteChar)"

# Need to ensure base folder has trailing backslash
if $so_c_base_folder.EndsWith("\") -ne $true {
    $so_c_base_folder = $so_c_base_folder + "\"
}
$so_c_base_folder = $so_c_base_folder + $survey_year + "\"
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

        # This gets the directory for the current survey type. The directories should end in "_A|O|R".
        $dir = Get-ChildItem -Path K:\SEAN_Data\Work_Zone\SO\SO_C\2022 -Name -Attributes Directory -Filter "*_$($survey_type.Substring(0,1))"
        $so_c_dir = $so_c_base_folder + $dir + "\"

        Write-Host "Renaming files in directory $($so_c_dir)..."

        $query = @"
		    SELECT s.PHOTO_FILE_NAME, s.PHOTO_TIMESTAMP_UTC, s.ORIGINAL_FILENAME
		    FROM [SO].[SO_D] s
            INNER JOIN [SO].[SURVEY_TYPE] st ON s.SURVEY_TYPE_ID = st.ID
		    WHERE DATEPART(year, s.PHOTO_TIMESTAMP_AK_LOCAL) = $($Survey_Year)
		    AND st.SURVEY_TYPE = $($Survey_Type)
		    AND ORIGINAL_FILENAME IN (
		    '0_000_00_001.jpg',
            '0_000_00_002.jpg',
            '0_000_00_003.jpg',
            '0_000_00_004.jpg',
            '0_000_00_005.jpg',
            '0_000_00_006.jpg',
            '0_000_00_007.jpg',
            '0_000_00_008.jpg',
            '0_000_00_009.jpg',
            '0_000_00_010.jpg',
            '0_000_00_011.jpg',
            '0_000_00_012.jpg'
            );
"@
        # For PS multi-line strings (above), the "@ chars on the last line MUST be the first two characters of that line,
        # so don't try to indent them to make it look pretty!

        Write-Host "query = $($query)"

        if ($sqlcmd.Connection.State -eq [System.Data.ConnectionState]::Closed) {
            $sqlconn.Open()
        }

        #$survey_date = [datetime]$sqlcmd.ExecuteScalar()


        # Build the export filename:
        #$outputFilename = "$($doubleQuoteChar)$($Output_folder)\SO_D_$($survey_date.ToString("yyyyMMdd"))_$($survey_type.Substring(0,1).ToUpper()).CSV$($doubleQuoteChar)"

        #ExportCSV -survey_type $survey_type -survey_year $survey_year -outputFilename $outputFilename -cmd $sqlcmd

        $sqlcmd.CommandType = 'Text'
        $sqlcmd.CommandText = $query

        $dr = $sqlcmd.ExecuteReader()

        while ($dr.Read()) {

            $so_c_filename = $dr.GetString(0)
            $photo_ts = $dr.GetDateTime(1)
            $orig_filename = $so_c_dir + $dr.Getstring(2)

            Rename-Item $orig_filename $so_c_filename

        } # end $dr while loop

        $dr.Close()

    
    } # foreach survey_type

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
