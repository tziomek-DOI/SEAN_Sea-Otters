<# 

    .SYNOPSIS
    rename_SO_C_filenames.ps1

    .DESCRIPTION
    The SO_C files (aerial photos) come out of the SeeOtter application with its version of filename formats.
    This script renames the photos to match the SEAN SO_C deliverable format.
    The SO_D database table has a mapping of the original and expected filenames. We query the database,
    and iterate/rename the files.

    .PARAMETER so_c_base_folder
    There are three subdirs for each survey year of SO_C. The base should be \\inpglbafs03\data\sean_data\work_zone\SO\SO_C\

    .PARAMETER server_name
    Name of the database server.

    .PARAMETER database_name
    Name of the database.

    .PARAMETER survey_year
    Year the survey was conducted. Will be appended to the so_c_base_folder parameter to build the photos archive directory.

    .EXAMPLE
    .\rename_SO_C_filenames.ps1 -so_c_base_folder \\inpglbafs03\data\SEAN_Data\Work_Zone\SO\SO_C\ -server_name inpglbafs03 -database_name SEAN_Staging_TEST_2017 -survey_year 2022

#>

<#
    UPDATES:

    TZ 2/29/2024: 
    - Created. Successfully run against 2022 SO_C on 3/1/2024.

    TZ 3/4/2024:
    - Added check for non-renamed files. For each found file, an Optional error record gets added to the SO_D_Validation table.

#>

# Script input parameters:
[CmdletBinding(SupportsShouldProcess)]
param (
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

# Set this variable to $true to toggle test mode:
$test_mode = $false

# Need to ensure base folder has trailing backslash
if ($so_c_base_folder.EndsWith("\") -ne $true) {
    $so_c_base_folder = $so_c_base_folder + "\"
}

if ($test_mode -eq $false) {
    $so_c_base_folder = $so_c_base_folder + $survey_year + "\"
} else {
    # for testing...
    $so_c_base_folder = $so_c_base_folder + $survey_year + "\test\"
}

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

        # Remove after testing:
        if ($test_mode -eq $true) {
            if ($survey_type -ne 'Abundance') { continue }
        }

        # This gets the directory for the current survey type. The directories should end in "_A|O|R".
        $dir = Get-ChildItem -Path K:\SEAN_Data\Work_Zone\SO\SO_C\2022 -Name -Attributes Directory -Filter "*_$($survey_type.Substring(0,1))"
        $so_c_dir = $so_c_base_folder + $dir + "\"

        Write-Host "Renaming files in directory $($so_c_dir)"
<#
        $query = @"
		    SELECT s.PHOTO_FILE_NAME, s.PHOTO_TIMESTAMP_UTC, s.ORIGINAL_FILENAME
		    FROM [SO].[SO_D] s
            INNER JOIN [SO].[SURVEY_TYPE] st ON s.SURVEY_TYPE_ID = st.ID
		    WHERE DATEPART(year, s.PHOTO_TIMESTAMP_AK_LOCAL) = $($Survey_Year)
		    AND st.SURVEY_TYPE = '$($Survey_Type)'
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
#>

        $query = @"
		    SELECT s.PHOTO_FILE_NAME, s.PHOTO_TIMESTAMP_UTC, s.ORIGINAL_FILENAME
		    FROM [SO].[SO_D] s
            INNER JOIN [SO].[SURVEY_TYPE] st ON s.SURVEY_TYPE_ID = st.ID
		    WHERE DATEPART(year, s.PHOTO_TIMESTAMP_AK_LOCAL) = $($Survey_Year)
		    AND st.SURVEY_TYPE = '$($Survey_Type)';
"@

        # For PS multi-line strings (above), the "@ chars on the last line MUST be the first two characters of that line,
        # so don't try to indent them to make it look pretty!

        Write-Host "query = $($query)"

        if ($sqlcmd.Connection.State -eq [System.Data.ConnectionState]::Closed) {
            $sqlconn.Open()
        }

        $sqlcmd.CommandType = 'Text'

# Remove this IF condition after running the SO_D_VALIDATION updates. The renaming portion is slow so no reason to redo it.
#if ($test_mode -eq $true) {
        $sqlcmd.CommandText = $query

        $dr = $sqlcmd.ExecuteReader()

        if ($dr.HasRows -ne $true) {
            Write-Host "ERROR: Query returned 0 records!"
            $dr.Close()
            throw
        } 

        while ($dr.Read()) {

            $so_c_filename = $dr.GetString(0)
            $photo_ts = $dr.GetDateTime(1)
            $orig_filename = $so_c_dir + $dr.Getstring(2)
            # test: success
            #$orig_filename = "\\inpglbafs03\data\sean_data\work_zone\so\so_c\2022\test\$($dr.Getstring(2))"

            Write-Host "Renaming $($orig_filename) to $($so_c_filename) ..."

            # Had to add -ErrorAction Stop to force it to throw an exception.
            # Does not seem prudent to let it keep processing.
            if ($test_mode -eq $false) {
                Rename-Item -Path $orig_filename -NewName $so_c_filename -ErrorAction Stop
            } else {
                # in test mode, we do not force a stop if the file is not found.
                Rename-Item -Path $orig_filename -NewName $so_c_filename -ErrorAction SilentlyContinue
            }

        } # end $dr while loop

        $dr.Close()
#} # end test - remove this line

        # Now search this SO_C directory and report any files that did not get renamed.
        # We could write a record to the SO_D_VALIDATION table since these are optional errors.
        $files_not_renamed = Get-ChildItem -Path $so_c_dir -Exclude "SO_C_*.JPG"
        Write-Host "Checking for files that did not get renamed..."

        foreach($ff in $files_not_renamed) { 
            #Write-Host "$($ff.Name),$($ff.CreationTime.ToString("yyyy-MM-dd HH:mm")),'Optional','Photo was not renamed.'" 
            $insert_sql = "INSERT INTO [SO].[SO_D_VALIDATION] VALUES ('$($ff.Name)','$($ff.CreationTime.ToString("yyyy-MM-dd HH:mm"))','Optional','Photo was not renamed.');"
            Write-Host "Adding to database: $($insert_sql)"
            $sqlcmd.CommandText = $insert_sql
            $recs_added = $sqlcmd.ExecuteNonQuery()
        }

    
    } # foreach survey_type

}
catch [Exception] {
    Write-Error $_.Exception.Message
    Write-Error ($_.Exception | Format-List -Force | Out-String) -ErrorAction Continue
    Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue
}
finally {
    if ($dr.IsClosed -ne $true) { $dr.Close() }
    if ($sqlcmd.Connection.State -ne [System.Data.ConnectionState]::Closed) {
        $sqlconn.Close()
    }
}
