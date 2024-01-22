/*
CREATE PROCEDURE SO.sp_load_CSVs_into_temp_table
 @output_execution_id bigint output
AS
BEGIN
	DECLARE @execution_id bigint

	EXEC ssisdb.catalog.create_execution 
	@folder_name = 'SO_D_importer_folder'
	,@project_name = 'CSV_SO_D_importer'
	,@package_name = 'CSV_to_SO_D_2022_w_transect.dtsx'
	,@execution_id = @execution_id output
	EXEC ssisdb.catalog.start_execution @execution_id
	SET @output_execution_id = @execution_id
END
*/

CREATE PROCEDURE [SO].[sp_load_CSVs_into_temp_table]
    @CSV_FILE_NAME		NVARCHAR(255)
	,@SERVER_NAME		NVARCHAR(25)
	,@DATABASE_NAME		NVARCHAR(50)
	,@EXECUTION_ID		BIGINT OUTPUT
AS
BEGIN
   -- 1. declare variables
	DECLARE
		@PROCEDURE_NAME		SYSNAME
		,@FOLDER_NAME		NVARCHAR(128)
		,@PROJECT_NAME		NVARCHAR(128)
		,@PACKAGE_NAME		NVARCHAR(128)
		,@PARAMETER_VALUE	NVARCHAR(255)
--		,@REFERENCE_ID    BIGINT;
		;

	-- 2. get this stored procedure's name
	SET @PROCEDURE_NAME = OBJECT_NAME(@@PROCID);
 
   -- 3. get the parameters for executing the SSIS package
/*
   SELECT 
       @FOLDER_NAME  = [FOLDER_NAME]   
   ,   @PROJECT_NAME = [PROJECT_NAME]   
   ,   @PACKAGE_NAME = [PACKAGE_NAME]  
   ,   @REFERENCE_ID = [REFERENCE_ID]
   FROM [dbo].[ProcedureToCreateExecutionMapping]
   WHERE [ProcedureName] = @PROCEDURE_NAME;
*/
	-- For initial test we will hard-code these values:
	SET @FOLDER_NAME = 'SO_D_importer_folder'
	SET @PROJECT_NAME = 'CSV_SO_D_importer'
	SET @PACKAGE_NAME = 'CSV_to_SO_D_2022_w_transect.dtsx'

	-- 4. check if 1 row was returned
	IF @@ROWCOUNT <> 1
		BEGIN
		-- throw error
--			RETURN;
			SET @EXECUTION_ID = -999;
			RETURN @EXECUTION_ID;
		END
 
	-- 5. create the package execution
	EXEC [SSISDB].[catalog].[create_execution]
		@folder_name = @FOLDER_NAME
		,@project_name = @PROJECT_NAME
		,@package_name = @PACKAGE_NAME
	--  ,@reference_id = @REFERENCE_ID
		,@execution_id = @EXECUTION_ID OUTPUT;
 
	-- 6. set value for Customer_Flat_File_Name package parameter
	--EXEC [SSISDB].[catalog].[set_execution_parameter_value]
	--	@execution_id = @EXECUTION_ID  
	--	,@object_type = 30 -- package parameter 
	--	,@parameter_name = N'Customer_Flat_File_Name'  
	--	,@parameter_value = @CUSTOMER_FLAT_FILE_NAME;

	-- 6. Set value for the package parameters:
	-- CSV file connection string:
	EXEC [SSISDB].[catalog].[set_execution_parameter_value]
		@execution_id = @EXECUTION_ID
		,@object_type = 30	-- package parameter
		,@parameter_name = N'[CSV_to_SO_D_2022_no_transect.dtsx].[CM.SourceConnectionFlatFile.ConnectionString]'
		,@parameter_value = @CSV_FILE_NAME;

	-- Database connection string:
	SET @PARAMETER_VALUE = 'Data Source=' + @SERVER_NAME + ';Initial Catalog=' + @DATABASE_NAME + ';Provider=SQLNCLI11;Integrated Security=SSPI;Auto Translate=false';
	EXEC [SSISDB].[catalog].[set_execution_parameter_value]
		@execution_id = @EXECUTION_ID
		,@object_type = 30	-- package parameter
		,@parameter_name = N'[CSV_to_SO_D_2022_no_transect.dtsx].[CM.DestinationConnectionOLEDB.ConnectionString]'
		,@parameter_value = @PARAMETER_VALUE;

	-- InitialCatalog:
	SET @PARAMETER_VALUE = 'Data Source=' + @SERVER_NAME + ';Initial Catalog=' + @DATABASE_NAME + ';Provider=SQLNCLI11;Integrated Security=SSPI;Auto Translate=false';
	EXEC [SSISDB].[catalog].[set_execution_parameter_value]
		@execution_id = @EXECUTION_ID
		,@object_type = 30	-- package parameter
		,@parameter_name = N'[CSV_to_SO_D_2022_no_transect.dtsx].[CM.DestinationConnectionOLEDB.InitialCatalog]'
		,@parameter_value = @DATABASE_NAME;
   
	-- 7. start the execution
	EXEC [SSISDB].[catalog].[start_execution]
		@execution_id = @EXECUTION_ID;
 
END
