Standard Operating Procedure - SO_D data loading, validation, export

1. Load the raw SeeOtter CSV files into the database temp table (SO_D_SeeOtter):
	a. Run PowerShell script 'load_SO_CSVs_into_temp_table.ps1', which is a wrapper to fire off the SSIS package that does the data load.
		Notes:
		- Setting the working directory correctly in PowerShell is key. The script must be launched while in it's directory, so, if the file is at  		c:\temp\load_SO_CSVs_into_temp_table.ps1, then user should open PowerShell, then cd c:\temp and then run the script, like so:
		PS> C:\temp\load_SO_CSVs_into_temp_table.ps1 -Config_file_dir C:\temp
		
		- The SSIS configuration parameters are name/value pairs which are saved to file 'load_SO_CSVs_into_temp_table_config.csv'.
		- By properly setting the -Config_file_dir parameter to ensure this CSV is inside, the script will execute correctly.

2. Transform the raw SeeOtter data into the current SO_D format, and import the data into the SO_D table.
	a. Execute stored procedure 'sp_insert_into_SO_D_from_temp_table' which transforms and loads the data from temp to the new SO_D table:
		- This is best done by executing PowerShell script 'insert_into_SO_D_from_temp_table.ps1' (but can also be done from SSMS directly). Requires input parameters. 
		Example:
		.\insert_into_SO_D_from_temp_table.ps1 -Folder "<path_to_csv_files>" -Filter *.csv -server <database_server_name> -database <database_name> -protocol <SEAN_protocol_version>

3. Perform preprocessing of the survey photos. This involves two separate procedures.
	- Rename the SO_C photos to the 'SO_C_*' format defined in the Sea Otter protocol/SOP.
		NOTE: This step may have been done previously, but the photo filenames should be checked prior to running the validation step to follow.
	- Extract the EXIF information from the photos into a database table named SO.SO_C_PHOTO_INFO. This information is used in the validation process. The script creates a CSV file, and then loads the CSV data into the table via BULK INSERT.

	NOTE: See the help documentation at the head of the PowerShell scripts for additional details.
	
	STEPS:
	a. Execute PowerShell script 'rename_SO_C_filenames.ps1'.
		- The -so_c_base_folder parameter should point to the directory which contains three subdirectories (one for each transect type).
	
	Syntax:
	.\rename_SO_C_filenames.ps1 -so_c_base_folder <path>\ -server_name <database_server_name> -database_name <database_name> -survey_year <yyyy>
	
	b. Execute PowerShell script 'extract_exif_info.ps1'.
	
	.\extract_exif_info.ps1 -base_folder <path>\ -server_name <database_server_name> -database_name <database_name> -survey_year <yyyy> -output_folder <output_folder_path>
	
4. Validate the data in the SO_D table.
	- This process validates the data in the SO_D table. The validation criteria is defined in the Data Quality Standards document for the Sea Otter vital sign, available on the NPS DataStore at https://irma.nps.gov/DataStore/Reference/Profile/2248281.
	- A PowerShell script named 'validate_SO_D_table.ps1' is the driver for the validation process. It executes a stored procedure named ''. The stored procedure validates each field for each record for the survey year specified in the command line parameter.
	- A database table named SO.SO_D_VALIDATION stores the records which did not meet the validation criteria. This information is also exported to a CSV file.
	
	STEPS:
	a. Execute PowerShell script 'validate_SO_D_table.ps1', with input parameters as shown in this example (the script has more detailed help):
	
	.\validate_SO_D_table.ps1 -server <database_server_name> -database <database_name> -survey_year <yyyy> -output_filename <path>\<filename>.csv
	
	b. Follow the data management procedures defined in the Sea Otter protocol and SOPs to manage the results of the validation.
	
5. Export the deliverable submission candidate CSV files from the SO_D table.
	- This step is only viable after successful validation from step 3 above.
	- The export can be configured to generate separate (Abundance/Optimal/Random), per-survey-year CSVs, which are then sent to USGS to generate the abundance estimate. Or, a single cumulative CSV containing all records for all survey years can be generated. This is used by the SEAN as the published SO_D DataStore deliverable. Note that for the cumulative CSV, the -survey_year parameter should be set to the latest survey year desired in the file. The script will automatically set the starting year to be 2017, which was the first year of surveys for this protocol. 
	
	STEPS:
	a. Execute PowerShell script 'export_CSVs_from_database.ps1'. 
	
	Example syntax:
	- To generate 3 separate CSVs for a single survey year:
	.\export_CSVs_from_database.ps1 -Output_folder "<path-to-export-directory>" -server_name <database_server_name> -database_name <database_name> -survey_year <yyyy> -is_cumulative $false
	
	- To generate one cumulative (all survey years) CSV:
	.\export_CSVs_from_database.ps1 -Output_folder "<path-to-export-directory>" -server_name <database_server_name> -database_name <database_name> -survey_year <ending-survey-year> -is_cumulative $true

