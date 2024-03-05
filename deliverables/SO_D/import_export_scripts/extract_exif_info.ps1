<# 
    .SYNOPSIS
    extract_exif_info.ps1

    .DESCRIPTION
    Extracts EXIF information from the SO_C photos and loads the info into the database table SO.SO_C_PHOTO_INFO.
    Currently only extracts the date photo was taken.

    .PARAMETER base_folder
    Set the base directory folder. This should be the SO_C for the desired survey year.
    There are three subdirs for each survey year of SO_C. The base should be \\inpglbafs03\data\sean_data\work_zone\SO\SO_C\

    .PARAMETER server_name
    Name of the database server.

    .PARAMETER database_name
    Name of the database.

    .PARAMETER survey_year
    Year the survey was conducted. Will be appended to the base_folder parameter to build the photos archive directory.

    .PARAMETER output_folder
    Specifies where to write the CSV file. Expect \\inpglbafs03\data\SEAN_Data\Work_Zone\SO\SO_D\<survey_year>\exported_files

    .EXAMPLE
    .\extract_exif_info.ps1 -base_folder \\inpglbafs03\data\SEAN_Data\Work_Zone\SO\SO_C\ -server_name inpglbafs03 -database_name SEAN_Staging_TEST_2017 -survey_year 2022 -output_folder \\inpglbafs03\data\SEAN_Data\Work_Zone\SO\SO_D\2022\exported_files

#>
<#
    UPDATES:

    TZ 2/28/2024: 
    - Script created.

    TODO:
    - Pipe the output of this script to a log file in the same directory as the CSV.
#>

# Script input parameters:
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory)]
    [String]
    $base_folder,

    # SQL Server connection info:
    [Parameter(Mandatory=$true)]
    [string]
    $server_name,

    [Parameter(Mandatory=$true)]
    [string]
    $database_name,

    [Parameter(Mandatory=$true)]
    [int]
    $survey_year,

    [Parameter(Mandatory)]
    [String]
    $output_folder
)

# Create the Get-ChildItem parameters:
<#
$fileSearchParams = @{
    Path = $Folder
    File = $true
    Filter = $Filter
}
#>

#if ($Filter) { $fileSearchParams += @{Include = $Filter}}
#$fileSearchParams += @{Include = $Filter}

# Load the files into a collection:
#$fileCollection = Get-ChildItem @fileSearchParams

if ($base_folder.EndsWith("\") -ne $true) { $base_folder = "$($base_folder)\" }
$base_folder = "$($base_folder)\$($survey_year)"
$so_c_dirs = Get-ChildItem -Path $base_folder -Directory

<#
Write-Host "Folder = " $Folder
Write-Host "File collection count = " $fileCollection.Count
#>

$sb = [System.Text.StringBuilder]::new()
$sqlconn = New-Object System.Data.SqlClient.SqlConnection
$sqlconn.ConnectionString = "Data Source=" + $server_name + ";Initial Catalog=" + $database_name + ";Integrated Security=true"
$sqlcmd = New-Object System.Data.SqlClient.SqlCommand

# Create a file which will store all the data that will get bulk-loaded into the database:
try {
    #$filePath = [System.IO.Path]::GetDirectoryName($temp)
    #$fileName = [System.IO.Path]::GetFileName($temp)

    # Delete the exif csv file if it exists:
    if (Test-Path "$($output_folder)\SO_C_$($survey_year)_EXIF.CSV") {
        Remove-Item "$($output_folder)\SO_C_$($survey_year)_EXIF.CSV" -Verbose
    }

    $newFile = New-Item -Path $output_folder -Name "SO_C_$($survey_year)_EXIF.CSV" -ItemType File

    # open a writable FileStream
    $fileStream = $newFile.OpenWrite()

    # create stream writer
    $streamWriter = [System.IO.StreamWriter]::new($fileStream)

    # Write column headers:
    [void]$streamWriter.WriteLine("ID,PHOTO_FILENAME,SURVEY_YEAR,SURVEY_TYPE,EXIF_PHOTO_DATE,NOTES")

    $sqlcmd.CommandType = 'Text'
    $sqlcmd.Connection = $sqlconn
    $sqlcmd.CommandTimeout = 0

    $rowid = 0

    # Loop through the SO_C subdirectories, then loop through all the photos, and save
    # the file EXIF data into the output .CSV file:
    foreach($so_c_dir in $so_c_dirs) {
        Write-Host "Iterating directory '$($so_c_dir.Name)'..."
        if ($so_c_dir.Name.EndsWith("A")) {
            $survey_type = 'Abundance'
        } elseif ($so_c_dir.Name.EndsWith("O")) {
            $survey_type = 'Optimal'
        } elseif ($so_c_dir.Name.EndsWith("R")) {
            $survey_type = 'Random'
        } else {
            Write-Host "Failed to determine the survey type based on the SO_C subdirectory '$($so_c_dir)' last character."
            continue;
        }

        $photos = Get-ChildItem -Path $so_c_dir.FullName -Filter "*.jpg"

        foreach($photo in $photos) {
            #$photo.FullName
            try {
                $bitmap = [System.Drawing.Bitmap]::new($photo.FullName)
                #$property_items = $bitmap.PropertyItems  # this would get all property items into an array

                # Get the datetime of image creation:
                $photo_dt_exif = $bitmap.GetPropertyItem(306)
                $ascii = [System.Text.ASCIIEncoding]::new()
                # Trim off the trailing null terminator:
                $decoded = $ascii.GetString($photo_dt_exif.Value[0..$($photo_dt_exif.Len-2)])
                # The decoded date format is yyyy:mm:dd HH:mm:ss
                # Replace the date colons with dashes
                [void]$sb.Clear()
                [void]$sb.Append($decoded)

                # For some reason, this "cleaner" code (using that term loosely) worked for the first
                # dash, but not the second one. Sleep deprivation? The new version works.
                #$sb[$decoded.IndexOf($decoded.Substring(4,1))] = '-'
                #Write-Host "char at index 7 = $($decoded.Substring(7,1))..."
                #$sb[$decoded.IndexOf($decoded.Substring(7,1))] = '-'
                $sb[4] = '-'
                $sb[7] = '-'
                $date_created = $sb.ToString()
                [void]$sb.Clear()
                Write-Host "$($photo) created on $($date_created)"

                $rowid++
                [void]$streamWriter.WriteLine("$($rowid),$($photo.Name),$($survey_year),$($survey_type),$($date_created),NULL")

            } catch {
                "ERROR with photo $($photo.FullName): $($_.Exception.Message)" | Out-Default
                Write-Error ($_.Exception | Format-List -Force | Out-String) -ErrorAction Continue
                Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue
                throw
            } # end try-catch

        } # end of loop thru photos
        $streamWriter.Flush()
    } # end of loop through so_c dirs

    $streamWriter.Close()

    # Do a bulk insert of the CSV file into table SO.SO_C_PHOTO_INFO
    $sqlcmd.CommandType = 'Text'
    $sqlquery =  @"
    BULK INSERT [SO].[SO_C_PHOTO_INFO]
    FROM '$($newFile)'
    WITH (FORMAT = 'CSV'
    ,FIRSTROW = 2
    ,FIELDTERMINATOR = ','
    ,ROWTERMINATOR = '0x0a');
"@
    Write-Host "query: $($sqlquery)"
    $sqlcmd.CommandText = $sqlquery
    $sqlconn.Open()
    $sqlcmd.ExecuteNonQuery()

    $retval = 0

} catch {
    "Program terminated due to error(s): $($_.Exception.Message)" | Out-Default
    Write-Error ($_.Exception | Format-List -Force | Out-String) -ErrorAction Continue
    Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue
    $retval = -999
} finally {
    #$streamWriter.Close()
    if ($sqlcmd.Connection.State -ne [System.Data.ConnectionState]::Closed) {
        $sqlconn.Close()
    }
    Write-Host "extract_exif_info.ps1 finished with exit code $($retval) (0 indicates success)."
} # end try-catch




