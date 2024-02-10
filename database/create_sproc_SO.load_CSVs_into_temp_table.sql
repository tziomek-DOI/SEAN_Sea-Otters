USE [SEAN_Staging_2017]
GO

/****** Object:  StoredProcedure [SO].[sp_load_CSVs_into_temp_table]    Script Date: 2/9/2024 2:49:10 PM 
 *
 * AUTHOR: tziomek
 * 
 * DESCRIPTION:
 * Executes the SSIS package which loads records from the input CSV file into the SO_D temp table.

******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [SO].[sp_load_CSVs_into_temp_table]
    @CSV_FILE_NAME		NVARCHAR(255)
	,@SERVER_NAME		NVARCHAR(25)
	,@DATABASE_NAME		NVARCHAR(50)
	,@FOLDER_NAME		NVARCHAR(128)
	,@PROJECT_NAME		NVARCHAR(128)
	,@PACKAGE_NAME		NVARCHAR(128)
	,@EXECUTION_ID		BIGINT OUTPUT
AS
BEGIN
   -- 1. declare variables
	DECLARE
		@PROCEDURE_NAME		SYSNAME
		,@PARAMETER_NAME	NVARCHAR(255)
		,@PARAMETER_VALUE	NVARCHAR(255)
		;

	-- 2. get this stored procedure's name
	SET @PROCEDURE_NAME = OBJECT_NAME(@@PROCID);
 
	-- 3. check if 1 row was returned
	IF @@ROWCOUNT <> 1
		BEGIN
		-- throw error
--			RETURN;
			SET @EXECUTION_ID = -999;
			RETURN @EXECUTION_ID;
		END
 
	-- 4. create the package execution
	EXEC [SSISDB].[catalog].[create_execution]
		@folder_name = @FOLDER_NAME
		,@project_name = @PROJECT_NAME
		,@package_name = @PACKAGE_NAME
		,@execution_id = @EXECUTION_ID OUTPUT;
 
	-- 5. Set values for the package parameters:
	-- CSV file connection string:
	EXEC [SSISDB].[catalog].[set_execution_parameter_value]
		@execution_id = @EXECUTION_ID
		,@object_type = 30	-- package parameter
		,@parameter_name = N'CM.SourceConnectionFlatFile.ConnectionString'
		,@parameter_value = @CSV_FILE_NAME;

	-- Database connection string:
	SET @PARAMETER_VALUE = 'Data Source=' + @SERVER_NAME + ';Initial Catalog=' + @DATABASE_NAME + ';Provider=SQLNCLI11;Integrated Security=SSPI;Auto Translate=false';
	EXEC [SSISDB].[catalog].[set_execution_parameter_value]
		@execution_id = @EXECUTION_ID
		,@object_type = 30	-- package parameter
		,@parameter_name = N'CM.DestinationConnectionOLEDB.ConnectionString'
		,@parameter_value = @PARAMETER_VALUE;

	-- InitialCatalog:
	SET @PARAMETER_VALUE = 'Data Source=' + @SERVER_NAME + ';Initial Catalog=' + @DATABASE_NAME + ';Provider=SQLNCLI11;Integrated Security=SSPI;Auto Translate=false';
	EXEC [SSISDB].[catalog].[set_execution_parameter_value]
		@execution_id = @EXECUTION_ID
		,@object_type = 30	-- package parameter
		,@parameter_name = N'CM.DestinationConnectionOLEDB.InitialCatalog'
		,@parameter_value = @DATABASE_NAME;
   
	-- 6. start the execution
	EXEC [SSISDB].[catalog].[start_execution]
		@execution_id = @EXECUTION_ID;
 
END
GO


