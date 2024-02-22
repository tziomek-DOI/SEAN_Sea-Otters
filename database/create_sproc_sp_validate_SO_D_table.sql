SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Thomas Ziomek
-- Create date: 2024-02-14
-- Description:	Validates the columns in the SO_D table, then updates the QUALITY_FLAG with the result.
-- =============================================
CREATE PROCEDURE [SO].[sp_validate_SO_D_table]
	-- Add the parameters for the stored procedure here
	@Survey_Year		INT
	--,@Survey_Type_IN	NVARCHAR(9) -- only needed if we pass in a param to filter
	,@Num_Recs			INT OUTPUT
	,@Error_Code		INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		-- Declare variables to store the fields for each fetch
		DECLARE
		@photo_file_name	NVARCHAR(30)
		,@photo_ts_utc		NVARCHAR(4000)
		,@photo_ts_ak		NVARCHAR(4000)
		,@latitude			DECIMAL(10,8)
		,@longitude			DECIMAL(11,8)
		,@altitude			INT
		,@survey_type		NVARCHAR(9)
		,@count_adult		INT
		,@count_pup			INT
		,@kelp_present		NVARCHAR(3)
		,@land_present		NVARCHAR(3)
		,@image_quality		NVARCHAR(8)
		,@counted_by		NVARCHAR(100)	-- will be initials for humans, or the SeeOtter version
		,@counted_date		NVARCHAR(4000)
		,@protocol			NVARCHAR(10)
		,@quality_flag		NVARCHAR(255)
		,@original_fn		NVARCHAR(30)
		,@flown_by			NVARCHAR(3)
		,@camera			NVARCHAR(101)
		,@transect			NVARCHAR(10)
		,@validated_by		NVARCHAR(3)
		,@date_last_upd		NVARCHAR(4000)
		,@last_upd_by		NVARCHAR(3)
		,@val_result		NVARCHAR(4000)	-- might not use
		,@has_mand_error	BIT				-- If set to 1, indicates presence of mandatory error

		SET @has_mand_error = 0;

		-- Create a cursor to interate the SO_D table, filtered by the survey year parameter
		-- Actually, let's run this against the view (which is what is actually used for the CSV export):
		DECLARE sod_cursor CURSOR FOR
		/*
		SELECT
		sod.PHOTO_FILE_NAME
		,sod.PHOTO_TIMESTAMP_UTC
		,sod.PHOTO_TIMESTAMP_AK_LOCAL
		,sod.LATITUDE_WGS84
		,sod.LONGITUDE_WGS84
		,sod.ALTITUDE
		,st.SURVEY_TYPE
		,sod.COUNT_ADULT
		,sod.COUNT_PUP
		,k.KELP_PRESENT
		,l.LAND_PRESENT
		,i.IMAGE_QUALITY
		-- If 'SO', this means the SeeOtter program did the counting, so output FULL_NAME.
		-- Otherwise, it means a person counted them so just output their initials.
		,CASE 
			WHEN e.INITIALS = 'SO' THEN e.FULL_NAME 
			ELSE e.INITIALS 
		END
		,sod.COUNTED_DATE
		,p.protocol
		,q.QUALITY_FLAG
		,ORIGINAL_FILENAME
		,f.INITIALS AS FLOWN_BY
		,(c.MAKE + ' ' + c.MODEL) AS CAMERA_SYSTEM
		,sod.TRANSECT
		,v.INITIALS AS VALIDATED_BY

		FROM [SO].[SO_D] sod
		INNER JOIN [SO].[SURVEY_TYPE] st ON sod.SURVEY_TYPE_ID = st.ID
		INNER JOIN SO.EMPLOYEE AS e ON sod.COUNTED_BY_ID = e.ID 
		INNER JOIN SEAN.tbl_protocol AS p ON sod.PROTOCOL_ID = p.id 
		INNER JOIN SO.QUALITY_FLAG AS q ON sod.QUALITY_FLAG_ID = q.ID 
		LEFT OUTER JOIN SO.EMPLOYEE AS f ON sod.FLOWN_BY_ID = f.ID 
		LEFT OUTER JOIN SO.CAMERA AS c ON sod.CAMERA_ID = c.ID 
		LEFT OUTER JOIN SO.EMPLOYEE AS v ON sod.VALIDATED_BY_ID = v.ID 
		INNER JOIN SO.EMPLOYEE AS cr ON sod.CREATED_BY_ID = cr.ID 
		INNER JOIN SO.EMPLOYEE AS up ON sod.LAST_UPDATED_BY_ID = up.ID 
		LEFT OUTER JOIN SO.KELP_PRESENT AS k ON sod.KELP_PRESENT_ID = k.ID 
		LEFT OUTER JOIN SO.LAND_PRESENT AS l ON sod.LAND_PRESENT_ID = l.ID 
		LEFT OUTER JOIN SO.IMAGE_QUALITY AS i ON sod.IMAGE_QUALITY_ID = i.ID
		WHERE DATEPART(year, sod.PHOTO_TIMESTAMP_AK_LOCAL) = @Survey_Year;
		*/

		SELECT * FROM [SO].[view_SO_D_allrecs_w_lookups]
		-- WHERE survey_type = @Survey_Type_IN;

		OPEN sod_cursor;
		FETCH NEXT FROM sod_cursor 
		INTO --var list (need to declare);
		@photo_file_name
		,@photo_ts_utc
		,@photo_ts_ak
		,@latitude
		,@longitude
		,@altitude
		,@survey_type
		,@count_adult
		,@count_pup
		,@kelp_present
		,@land_present
		,@image_quality
		,@counted_by
		,@counted_date
		,@protocol
		,@quality_flag
		,@original_fn
		,@flown_by
		,@camera
		,@transect
		,@validated_by
		,@date_last_upd
		,@last_upd_by
		;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Validate the column values here
			-- If fails, write message to @val_result. Can concat multiple if kept succinct

			--if ( !Regex.IsMatch(strPhotoFileName, "^SO_C_[0-9]{8}_[AORX]_[0-9]{4}\\.JPG$", RegexOptions.IgnoreCase) )	
			IF @photo_file_name NOT LIKE '^SO_C_[0-9]{8}_[AORX]_[0-9]{4}\\.JPG$'
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Invalid filename format.');
				SET @has_mand_error = 1;
			
			--if (!@photo_ts_utc between 2017 and getdate())
			IF DATEPART(year, @photo_ts_utc) NOT BETWEEN 2017 AND DATEPART(year, GETDATE())
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Timestamp must be between year 2017 and the present year.');
				SET @has_mand_error = 1;

			--if not between may and august
			IF DATEPART(month, @photo_ts_utc) NOT BETWEEN 5 AND 8
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Survey month not between May and August.');
			
			--if (!@photo_ts_ak betweem 2017 and getdate())
			IF DATEPART(year, @photo_ts_ak) NOT BETWEEN 2017 AND DATEPART(year, GETDATE())
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Timestamp must be between year 2017 and the present year.');
				SET @has_mand_error = 1;

			--if not between may and august
			IF DATEPART(month, @photo_ts_ak) NOT BETWEEN 5 AND 8
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Survey month not between May and August.');

			IF @latitude NOT BETWEEN 58.0 AND 60.0
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Latitude not between 58.0 and 60.0.');

			IF @longitude NOT BETWEEN -138.0 AND -135.0
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Longitude not between -135.0 and -138.0.');

			IF @altitude NOT BETWEEN 150 AND 300
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Altitude not between 150 and 300.');

			--IF (!@Survey_Type IN ('Abundance','Random','Optimal') ??
			IF NOT (SUBSTRING(@photo_file_name, 15, 1) = 'A' AND @survey_type = 'Abundance')
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Survey type does not match the type denoted in the photo filename.');
				SET @has_mand_error = 1;

			IF NOT (SUBSTRING(@photo_file_name, 15, 1) = 'O' AND @survey_type = 'Optimal')
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Survey type does not match the type denoted in the photo filename.');
				SET @has_mand_error = 1;

			IF NOT (SUBSTRING(@photo_file_name, 15, 1) = 'R' AND @survey_type = 'Random')
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Survey type does not match the type denoted in the photo filename.');
				SET @has_mand_error = 1;
			
			--if (!@count_adult/pup between -22222 AND 1000) -- then unusual count warning...maybe just > 1000, the other was for C#
			IF @count_adult NOT BETWEEN 0 AND 1000
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Adult count not between 0 and 1000.');

			IF @count_pup NOT BETWEEN 0 AND 1000
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Pup count not between 0 and 1000.');

			-- kelp/land
			IF @kelp_present IS NOT NULL AND @kelp_present NOT IN (SELECT KELP_PRESENT FROM KELP_PRESENT)
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Invalid value for KELP_PRESENT.');
				SET @has_mand_error = 1;

			IF DATEPART(year, @photo_ts_ak) < 2022 AND @kelp_present IS NULL
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'KELP_PRESENT must not be NULL prior to survey year 2022.');
				SET @has_mand_error = 1;

			IF @land_present IS NOT NULL AND @land_present NOT IN (SELECT LAND_PRESENT FROM LAND_PRESENT)
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Invalid value for LAND_PRESENT.');
				SET @has_mand_error = 1;

			IF DATEPART(year, @photo_ts_ak) < 2022 AND @land_present IS NULL
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'LAND_PRESENT must not be NULL prior to survey year 2022.');
				SET @has_mand_error = 1;

			-- image quality
			-- Not used after 2019, pending future enhancements. For SeeOtter 2022-tbd, shall be empty...how to validate?
			IF @image_quality IS NOT NULL AND @image_quality NOT IN (SELECT IMAGE_QUALITY FROM IMAGE_QUALITY)
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Invalid value for IMAGE_QUALITY.');
				SET @has_mand_error = 1;

			IF DATEPART(year, @photo_ts_ak) < 2022 AND @image_quality IS NULL
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'IMAGE_QUALITY must not be NULL prior to survey year 2022.');
				SET @has_mand_error = 1;

			-- counted_date
			IF @counted_date IS NULL OR DATEPART(year, @counted_date) NOT BETWEEN 2017 AND GETDATE() -- why would it be null? why is the field nullable??
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'COUNTED_DATE must not be NULL, and must be between year 2017 and the current year.');
				SET @has_mand_error = 1;

			-- Protocol
			--if (!startswith 'SO-' or len < x chars)
			IF LEN(@protocol) NOT BETWEEN 4 AND 16 -- TODO: Revisit these choices...were pulled from the C# code.
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Protocol should be between 4 and 16 characters in length.');
				SET @has_mand_error = 1;

			IF @protocol NOT LIKE 'SO-2%'
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Protocol name should start with SO-<year>.');

			-- Original Filename (SeeOtter)
			--if ( !Regex.IsMatch(column, "^[01]{1}_[0-9]{3}_[0-9]{2}_[0-9]{3,6}.JPG$", RegexOptions.IgnoreCase) )
			IF @original_fn NOT LIKE '^[01]{1}_[0-9]{3}_[0-9]{2}_[0-9]{3,6}.JPG$'
                 --strOptMessage += colname + " (" + column + ") format is not 9_999_99_00999.jpg. ";
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Invalid filename format for ORIGINAL_FILENAME (expected format is 9_999_99_00999.jpg).');
				SET @has_mand_error = 1;

			-- Flown by - not sure what needs done
			IF LEN(@flown_by) < 2
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Flown_By initials should have at least 2 characters.');

			IF DATEPART(year, @photo_ts_ak) >= 2022 AND @flown_by IS NULL
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Flown_By should not be null for surveys starting in year 2022.');

			-- Camera - not sure
			IF @camera NOT IN (SELECT MAKE + ' ' + MODEL FROM CAMERA)
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Camera does not match any database entries - verify.');

			-- Transect - not sure...somewhat undefined column at this time (future enhancement). Should be NA for all?
			IF @transect != 'NA'
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Transect not currently implemented, and should be NA.');

			-- Validated_By - not sure...QA should handle 
			IF LEN(@validated_by) < 2
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Validated_By initials should have at least 2 characters.');

			IF DATEPART(year, @photo_ts_ak) >= 2022 AND @validated_by IS NULL
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Validated_By should not be null for surveys starting in year 2022.');

			-- Update the SO_D table with the QUALITY_FLAG, DATE_LAST_UPDATED,  LAST_UPDATED_BY_ID
			IF @has_mand_error = 1
				UPDATE [SO].[SO_D]
				SET QUALITY_FLAG_ID = (SELECT QUALITY_FLAG_ID FROM QUALITY_FLAG WHERE QUALITY_FLAG = 'Provisional' AND DESCRIPTION NOT LIKE 'Deprecated%')
				,DATE_LAST_UPDATED = GETDATE()
				,LAST_UPDATED_BY_ID = (SELECT ID FROM [SO].[EMPLOYEE] WHERE USERNAME = SYSTEM_USER) -- will return nps\username so db entry must have domain
				WHERE PHOTO_FILE_NAME = @photo_file_name
				AND PHOTO_TIMESTAMP_AK_LOCAL = @photo_ts_ak; -- not necessary?? filenames should be unique?
			ELSE
				UPDATE [SO].[SO_D]
				SET QUALITY_FLAG_ID = (SELECT QUALITY_FLAG_ID FROM QUALITY_FLAG WHERE QUALITY_FLAG = 'Accepted' AND DESCRIPTION NOT LIKE 'Deprecated%')
				,DATE_LAST_UPDATED = GETDATE()
				,LAST_UPDATED_BY_ID = (SELECT ID FROM [SO].[EMPLOYEE] WHERE USERNAME = SYSTEM_USER)
				WHERE PHOTO_FILE_NAME = @photo_file_name
				AND PHOTO_TIMESTAMP_AK_LOCAL = @photo_ts_ak; -- not necessary?? filenames should be unique?


			-- Get the next record, then loop:
			FETCH NEXT FROM sod_cursor
			INTO --var list;
			@photo_file_name
			,@photo_ts_utc
			,@photo_ts_ak
			,@latitude
			,@longitude
			,@altitude
			,@survey_type
			,@count_adult
			,@count_pup
			,@kelp_present
			,@land_present
			,@image_quality
			,@counted_by
			,@counted_date
			,@protocol
			,@quality_flag
			,@original_fn
			,@flown_by
			,@camera
			,@transect
			,@validated_by
			,@date_last_upd
			,@last_upd_by
			;
		END

		CLOSE sod_cursor;
		DEALLOCATE sod_cursor;

		SET @Num_Recs = @@ROWCOUNT;
		return 0;
	END TRY BEGIN CATCH
		SET @Error_Code = @@ERROR;
		return error_number()
	END CATCH
END
GO
