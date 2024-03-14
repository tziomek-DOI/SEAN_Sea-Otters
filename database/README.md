Procedure to create database objects which support the SO_D deliverable process.

# TODO: Convert this to an official SOP and publish to DataStore.

1. Run script 'drop_create_SO_tables.sql' to create all the new tables, populate the lookup tables, and create relationships.
   - Script will check for object existence.
   
2. Create and populate the pre-SeeOtter (2017-2019 survey years) table (SO_D_2019): 
	a. Run script 'SO.SO_D_2019.Table.sql'. This creates an SO_D_2019 table and loads all the data from 2017-2019.
		- 46832 rows affected (result of insert)
		
		Notes:
			- Be mindful of the three database name references in the script to ensure correct loading.
			- This should be a one-time operation.
	
	b. Run 'insert_2019_table_into_new_SO_D_table.sql' to populate the new SO_D table with the 2017-2019 data.
		- This is also a one-time operation.

3. Run scripts:
	a. 'create_functions_DST_start-end_dates.sql'
		- These functions determine the start and end dates of daylight savings time based on the input year.
	b. 'create_alter_view_SO_D_allrecs_w_lookups.sql'
		- A flattened view of the SO_D table which will be used for the CSV export.
	c. 'drop_create_sproc_sp_insert_into_SO_D_from_temp_table.sql' 
		- Performs transformations, then loads data from the SO_D temp table ('SO_D_SeeOtter', which contains raw SeeOtter CSV data) into the main SO_D table.
	d. 'create_sproc_SO.load_CSVs_into_temp_table.sql'

4. Create the SSIS package which loads the raw SeeOtter CSV files into table SO_D_SeeOtter (temp table).
	a. Use SQL Server Management Studio to import the file 'CSV_to_SO_D_SeeOtter.dtsx'.
		- The file is XML and can be edited to suit ones' naming preferences, but care must be taken. Best to just use the defaults,
		  which need a Project structure within SSMS Integration Services Catalogs as follows:
		  - Folder: SO_D_importer_folder
			- Projects: CSV_SO_D_importer
				- Packages: CSV_to_SO_D_SeeOtter.dtsx
