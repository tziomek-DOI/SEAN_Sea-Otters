USE [SEAN_Staging_2017]
GO

/****** Object:  StoredProcedure [SO].[sp_insert_into_SO_D_from_temp_table]    Script Date: 2/9/2024 3:45:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ===============================================================================
-- Author:		Thomas Ziomek
-- Create date: 2023-12-27
-- Description:	Performs transformations and then loads data from the SO_D 
--              temp table (containing raw CSV data) into the SO.SO_D table.
-- Parameters:
-- @Counted_Date: Value to be extracted via calling program.
-- @Protocol: Protocol/version used in the generation of the records.
-- @Survey_Type: Single char ('A','R','O') to help filter which records to update.
-- @Survey_Year: Year the survey was conducted.
--
-- UPDATES:
--	TZ	20240117:
--	Added TRANSECT column to the SQL.
--	Removed database qualifiers from SQL 'FROM' clauses
--
-- TODO:
-- Currently no SeeOtter support for KELP_PRESENT, LAND_PRESENT, IMAGE_QUALITY.
-- ===============================================================================
CREATE PROCEDURE [SO].[sp_insert_into_SO_D_from_temp_table] 
	-- Add the parameters for the stored procedure here
	@Counted_Date datetime
	,@Protocol nvarchar(20)
	,@Survey_Type varchar(1)
	,@Survey_Year int
	,@Num_Recs int OUTPUT
	,@Error_Code int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		-- DECLARE variables for Daylight Savings Time checking
		DECLARE
		@DST_Start smalldatetime
		,@DST_End smalldatetime
		,@time_zone nvarchar(6)

		-- Extract the year, then get the start/end dates for that year:
		set @DST_Start = (SELECT dbo.fn_GetDaylightSavingsTimeStart(CONVERT(varchar,@Survey_Year)))
		set @DST_End = (SELECT dbo.fn_GetDaylightSavingsTimeEnd(CONVERT(varchar,@Survey_Year)))

		INSERT INTO [SO].[SO_D]
		(PHOTO_FILE_NAME,PHOTO_TIMESTAMP_UTC,PHOTO_TIMESTAMP_AK_Local,LATITUDE_WGS84,LONGITUDE_WGS84,ALTITUDE,SURVEY_TYPE_ID,COUNT_ADULT,COUNT_PUP,IMAGE_QUALITY_ID,
		COUNTED_BY_ID,COUNTED_DATE,PROTOCOL_ID,QUALITY_FLAG_ID,ORIGINAL_FILENAME,FLOWN_BY_ID,CAMERA_ID,TRANSECT,VALIDATED_BY_ID,
		DATE_CREATED,CREATED_BY_ID,DATE_LAST_UPDATED,LAST_UPDATED_BY_ID)

		SELECT 
			CONCAT('SO_C_',DATEPART(year, s.PHOTO_TIMESTAMP),RIGHT('0' + RTRIM(MONTH(s.PHOTO_TIMESTAMP)),2),RIGHT('0' + RTRIM(DAY(s.PHOTO_TIMESTAMP)),2),'_',SUBSTRING(s.SURVEY_TYPE,1,1),
			'_', RIGHT('00000' + RTRIM(s.ImageID),5), '.JPG') --AS PHOTO_FILE_NAME
			,FORMAT(s.PHOTO_TIMESTAMP, 'yyyy-MM-dd HH:mm:ss') -- SeeOtter should be UTC by default
		
			-- We could assume all Sea Otter surveys will be conducted during Daylight Savings Time months, but we'll program for it just in the hopes DST gets abolished someday!
			,CASE WHEN s.PHOTO_TIMESTAMP BETWEEN @DST_Start AND @DST_End THEN CAST(s.PHOTO_TIMESTAMP AT TIME ZONE 'UTC' AT TIME ZONE 'UTC-08' AS datetime) --AS [UTC-to-AKDT]
				ELSE CAST(s.PHOTO_TIMESTAMP AT TIME ZONE 'UTC' AT TIME ZONE 'UTC-09' AS datetime) --AS [UTC-to-AKST]
				END
			,s.LATITUDE_WGS84
			,s.LONGITUDE_WGS84
			,s.ALTITUDE
			,(SELECT st.ID FROM [SO].[SURVEY_TYPE] st WHERE st.SURVEY_TYPE = s.SURVEY_TYPE) --AS SURVEY_TYPE_ID
			,s.COUNT_ADULT
			,s.COUNT_PUP
			--,s.KELP_PRESENT_ID
			--,s.LAND_PRESENT_ID
			,(SELECT i.ID FROM [SO].[IMAGE_QUALITY] i WHERE i.IMAGE_QUALITY = s.IMAGE_QUALITY) --AS IMAGE_QUALITY_ID
			,(SELECT e.ID FROM [SO].[EMPLOYEE] e WHERE e.AFFILIATION = s.SeeOtter_VERSION) --AS COUNTED_BY_ID
			-- We need something for COUNTED_DATE...likely, the date SeeOtter was run to create the CSV, which is then loaded into the temp table.
			-- For 2022 we can use 11/3/2023
			-- Going forward, here is where the COUNTED_DATE input parameter will be placed, once this goes into a stored proc
			-- Logic:
			-- Check the PHOTO_TIMESTAMP year and survey type. Update COUNTED_DATE only for matching records:
			,CASE
				WHEN DATEPART(year, s.PHOTO_TIMESTAMP) = @Survey_Year AND @Survey_Type = SUBSTRING(s.SURVEY_TYPE,1,1) THEN @Counted_Date
				--ELSE DATEFROMPARTS(DATEPART(year, @Counted_Date),01,01)
			END
			-- Protocol will also be an input param from a stored proc.
			,(SELECT p.ID FROM [SEAN].tbl_protocol p WHERE p.protocol = @Protocol) --AS PROTOCOL_ID
			,4 -- indicates record has not yet been QC'd...we can update this during validation.
			,SUBSTRING(s.FilePath, PATINDEX('%%\[01]_[0]_[0]_%%', s.FilePath)+1,LEN(s.FilePath)-PATINDEX('%%\[01]_[0]_[0]_%%', s.FilePath)) --AS original_filename
			,(SELECT e.ID FROM [SO].[EMPLOYEE] e WHERE e.INITIALS = s.FLOWN_BY) --AS FLOWN_BY_ID
			,(SELECT c.ID FROM [SO].[CAMERA] c WHERE c.DESCRIPTION = s.CAMERA_SYSTEM) --AS CAMERA_ID
			,CASE
				WHEN (s.Transect IS NULL OR TRIM(s.Transect) = '') THEN 'NA'
				ELSE s.Transect
			END -- AS TRANSECT
			,(SELECT e.ID FROM [SO].[EMPLOYEE] e WHERE e.INITIALS = s.VALIDATED_BY) --AS VALIDATED_BY_ID
			,GETDATE()
			,6
			,GETDATE()
			,6
		FROM [SO].[SO_D_2022] s
		WHERE SUBSTRING(s.SURVEY_TYPE,1,1) = @Survey_Type;
	
		SET @Num_Recs = @@ROWCOUNT;
		return 0;
	END TRY BEGIN CATCH
		SET @Error_Code = @@ERROR;
		return error_number()
	END CATCH
END
GO


