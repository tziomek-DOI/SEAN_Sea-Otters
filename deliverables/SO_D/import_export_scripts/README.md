Standard Operating Procedure - SO_D data loading, validation, export

1. Load the raw SeeOtter CSV files into the database temp table (SO_D_SeeOtter):
	a. Run PowerShell script 'load_SO_CSVs_into_temp_table.ps1', which is a wrapper to fire off the SSIS package that does the data load.
		Notes:
		- Setting the working directory correctly in PowerShell is key. The script must be launched while in it's directory, so, if the file is at  		c:\temp\load_SO_CSVs_into_temp_table.ps1, then user should open PowerShell, then cd c:\temp and then run the script, like so:
		PS> C:\temp\load_SO_CSVs_into_temp_table.ps1 -Config_file_dir C:\temp
		
		- The SSIS configuration parameters are name/value pairs which are saved to file 'load_SO_CSVs_into_temp_table_config.csv'.
		- By properly setting the -Config_file_dir parameter to ensure this CSV is inside, the script will execute correctly.

