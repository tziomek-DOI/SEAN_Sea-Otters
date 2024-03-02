USE [SEAN_Staging_2017]
GO

/****** Object:  StoredProcedure [SO].[sp_validate_SO_D_table]    Script Date: 3/1/2024 3:40:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Thomas Ziomek
-- Create date: 2024-02-14
-- Description:	Validates the columns in the SO_D table, then updates the QUALITY_FLAG with the result.
--
-- Usage Notes:
-- One noteworthy prerequisite is this procedure expects that the "extract_exif_info" powershell script
-- has been run and the SO_C_PHOTO_INFO table has been updated with the info from the SO_C_2022_EXIF.CSV
-- file, which was created by the powershell script.
--
-- Updates:
-- TZ 3/1/24:
--		Added validation of the photo creation date. Compares the timestamp in the SO_D table for each image
--		with the EXIF date extracted directly from the photo (in table SO_C_PHOTO_INFO). This check is a good
--		means to ensure the correct photos were copied into the SO_C.
--
-- =============================================
CREATE OR ALTER         PROCEDURE [SO].[sp_validate_SO_D_table]
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
		,@mand_err_count	INT				-- Keep a count, and use if too many errors occur.
		,@opt_err_count		INT

		SET @has_mand_error = 0;
		SET @mand_err_count = 0;
		SET @opt_err_count = 0;

		-- Create a cursor to interate the SO_D table, filtered by the survey year parameter
		-- Actually, let's run this against the view (which is what is actually used for the CSV export):
		DECLARE sod_cursor CURSOR FOR

		SELECT
		PHOTO_FILE_NAME
		,PHOTO_TIMESTAMP_UTC
		,PHOTO_TIMESTAMP_AK_LOCAL
		,LATITUDE_WGS84
		,LONGITUDE_WGS84
		,ALTITUDE
		,SURVEY_TYPE
		,COUNT_ADULT
		,COUNT_PUP
		,KELP_PRESENT
		,LAND_PRESENT
		,IMAGE_QUALITY
		,COUNTED_BY
		,COUNTED_DATE
		,protocol
		,QUALITY_FLAG
		,ORIGINAL_FILENAME
		,FLOWN_BY
		,CAMERA_SYSTEM
		,TRANSECT
		,VALIDATED_BY
		,DATE_LAST_UPDATED
		,LAST_UPDATED_BY
		FROM [SO].[view_SO_D_allrecs_w_lookups]
		WHERE DATEPART(year, PHOTO_TIMESTAMP_AK_LOCAL) = @Survey_Year;

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
			--IF @photo_file_name NOT LIKE '^SO_C_[0-9]{8}_[AORX]_[0-9]{4}\\.JPG$'
			IF SUBSTRING(@photo_file_name,1,5) != 'SO_C_' OR
			   SUBSTRING(@photo_file_name, 14, 3) NOT IN ('_A_','_R_','_O_') OR
			   RIGHT(@photo_file_name, 4) != '.JPG' OR
			   ISDATE(SUBSTRING(@photo_file_name, 6, 8)) != 1 OR
			   ISNUMERIC(SUBSTRING(@photo_file_name, 17, PATINDEX('%.JPG%', @photo_file_name) - 17)) != 1
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Invalid filename format.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			--if (!@photo_ts_utc between 2017 and getdate())
			IF DATEPART(year, @photo_ts_utc) NOT BETWEEN 2017 AND DATEPART(year, GETDATE())
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Timestamp must be between year 2017 and the present year.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			--if not between may and august
			IF DATEPART(month, @photo_ts_utc) NOT BETWEEN 5 AND 8
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Survey month not between May and August.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			/*	
				Verify photo EXIF date created.
				Note that the photo_timestamp fields are only set up to the hour and minute, whereas the EXIF pulled the seconds as well.
				For now, we need to truncate the seconds. We lose a little fidelity here, but the main goal is to detect a more global issue,
				such as, the builder of the SO_C copied an entire folder incorrectly into one of the SO_C folders. It's less likely that
				individual files will have been mis-copied.
			 */
			IF FORMAT(CONVERT(datetime, @photo_ts_utc), 'yyyy-MM-dd HH:mm') != (SELECT FORMAT([EXIF_PHOTO_DATE], 'yyyy-MM-dd HH:mm') FROM [SO].[SO_C_PHOTO_INFO] WHERE PHOTO_FILENAME = @photo_file_name)
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Timestamp must match EXIF timestamp from table SO_C_PHOTO_INFO.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			--if (!@photo_ts_ak betweem 2017 and getdate())
			IF DATEPART(year, @photo_ts_ak) NOT BETWEEN 2017 AND DATEPART(year, GETDATE())
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Timestamp must be between year 2017 and the present year.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			--if not between may and august
			IF DATEPART(month, @photo_ts_ak) NOT BETWEEN 5 AND 8
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Survey month not between May and August.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			IF @latitude NOT BETWEEN 58.0 AND 60.0
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Latitude not between 58.0 and 60.0.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			IF @longitude NOT BETWEEN -138.0 AND -135.0
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Longitude not between -135.0 and -138.0.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			IF @altitude NOT BETWEEN 150 AND 300
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Altitude not between 150 and 300.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			--IF (!@Survey_Type IN ('Abundance','Random','Optimal') ??
			IF (SUBSTRING(@photo_file_name, 15, 1) = 'A' AND @survey_type != 'Abundance')
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Survey type does not match the type denoted in the photo filename.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			IF (SUBSTRING(@photo_file_name, 15, 1) = 'O' AND @survey_type != 'Optimal')
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Survey type does not match the type denoted in the photo filename.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			IF (SUBSTRING(@photo_file_name, 15, 1) = 'R' AND @survey_type != 'Random')
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Survey type does not match the type denoted in the photo filename.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;
			
			--if (!@count_adult/pup between -22222 AND 1000) -- then unusual count warning...maybe just > 1000, the other was for C#
			IF @count_adult NOT BETWEEN 0 AND 1000
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Adult count not between 0 and 1000.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			IF @count_pup NOT BETWEEN 0 AND 1000
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Pup count not between 0 and 1000.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			-- kelp/land
			IF @kelp_present IS NOT NULL AND @kelp_present NOT IN (SELECT KELP_PRESENT FROM KELP_PRESENT)
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Invalid value for KELP_PRESENT.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			IF DATEPART(year, @photo_ts_ak) < 2022 AND @kelp_present IS NULL
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'KELP_PRESENT must not be NULL prior to survey year 2022.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			IF @land_present IS NOT NULL AND @land_present NOT IN (SELECT LAND_PRESENT FROM LAND_PRESENT)
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Invalid value for LAND_PRESENT.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			IF DATEPART(year, @photo_ts_ak) < 2022 AND @land_present IS NULL
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'LAND_PRESENT must not be NULL prior to survey year 2022.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			-- image quality
			-- Not used after 2019, pending future enhancements. For SeeOtter 2022-tbd, shall be empty...how to validate?
			IF @image_quality IS NOT NULL AND @image_quality NOT IN (SELECT IMAGE_QUALITY FROM IMAGE_QUALITY)
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Invalid value for IMAGE_QUALITY.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			IF DATEPART(year, @photo_ts_ak) < 2022 AND @image_quality IS NULL
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'IMAGE_QUALITY must not be NULL prior to survey year 2022.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			-- counted_date
			IF @counted_date IS NULL OR DATEPART(year, @counted_date) NOT BETWEEN 2017 AND GETDATE() -- why would it be null? why is the field nullable??
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'COUNTED_DATE must not be NULL, and must be between year 2017 and the current year.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			-- Protocol
			--if (!startswith 'SO-' or len < x chars)
			IF LEN(@protocol) NOT BETWEEN 4 AND 16 -- TODO: Revisit these choices...were pulled from the C# code.
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Protocol should be between 4 and 16 characters in length.');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			IF @protocol NOT LIKE 'SO-20%'
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Protocol name should start with SO-<year>.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			-- Original Filename (SeeOtter)
			--if ( !Regex.IsMatch(column, "^[01]{1}_[0-9]{3}_[0-9]{2}_[0-9]{3,6}.JPG$", RegexOptions.IgnoreCase) )
			--IF @original_fn NOT LIKE '^[01]{1}_[0-9]{3}_[0-9]{2}_[0-9]{3,6}.JPG$'
			IF SUBSTRING(@original_fn, 1, 1) NOT IN (0,1) OR
			   SUBSTRING(@original_fn, 2, 8) != '_000_00_' OR
			   RIGHT(UPPER(@original_fn), 4) != '.JPG' OR
			   ISNUMERIC(SUBSTRING(@original_fn, 10, PATINDEX('%.JPG%', UPPER(@original_fn)) - 10)) != 1
			BEGIN
                 --strOptMessage += colname + " (" + column + ") format is not 9_999_99_00999.jpg. ";
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Mandatory', 'Invalid filename format for ORIGINAL_FILENAME (expected format is 9_999_99_00999.jpg).');
				SET @has_mand_error = 1;
				SET @mand_err_count = @mand_err_count + 1;
			END;

			-- Flown by - not sure what needs done
			IF LEN(@flown_by) < 2
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Flown_By initials should have at least 2 characters.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			IF DATEPART(year, @photo_ts_ak) >= 2022 AND @flown_by IS NULL
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Flown_By should not be null for surveys starting in year 2022.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			-- Camera - not sure
			IF @camera NOT IN (SELECT MAKE + ' ' + MODEL FROM CAMERA)
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Camera does not match any database entries - verify.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			-- Transect - not sure...somewhat undefined column at this time (future enhancement). Should be NA for all?
			IF @transect != 'NA'
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Transect not currently implemented, and should be NA.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			-- Validated_By - not sure...QA should handle 
			IF LEN(@validated_by) < 2
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Validated_By initials should have at least 2 characters.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			IF DATEPART(year, @photo_ts_ak) >= 2022 AND @validated_by IS NULL
			BEGIN
				INSERT INTO [SO].[SO_D_VALIDATION] (PHOTO_FILE_NAME, PHOTO_TIMESTAMP_AK_LOCAL, ERROR_TYPE, ERROR_DETAILS) VALUES (@photo_file_name, @photo_ts_ak, 'Optional', 'Validated_By should not be null for surveys starting in year 2022.');
				SET @opt_err_count = @opt_err_count + 1;
			END;

			-- Update the SO_D table with the QUALITY_FLAG, DATE_LAST_UPDATED,  LAST_UPDATED_BY_ID
			IF @has_mand_error = 1
				UPDATE [SO].[SO_D]
				SET QUALITY_FLAG_ID = (SELECT ID FROM [SO].[QUALITY_FLAG] WHERE QUALITY_FLAG = 'Provisional' AND DESCRIPTION NOT LIKE 'Deprecated%')
				,DATE_LAST_UPDATED = GETDATE()
				,LAST_UPDATED_BY_ID = (SELECT ID FROM [SO].[EMPLOYEE] WHERE USERNAME = SYSTEM_USER) -- will return nps\username so db entry must have domain
				WHERE PHOTO_FILE_NAME = @photo_file_name
				AND PHOTO_TIMESTAMP_AK_LOCAL = @photo_ts_ak; -- not necessary?? filenames should be unique?

			ELSE
				UPDATE [SO].[SO_D]
				SET QUALITY_FLAG_ID = (SELECT ID FROM [SO].[QUALITY_FLAG] WHERE QUALITY_FLAG = 'Accepted' AND (DESCRIPTION IS NULL OR DESCRIPTION NOT LIKE 'Deprecated%'))
				,DATE_LAST_UPDATED = GETDATE()
				,LAST_UPDATED_BY_ID = (SELECT ID FROM [SO].[EMPLOYEE] WHERE USERNAME = SYSTEM_USER)
				WHERE PHOTO_FILE_NAME = @photo_file_name
				AND PHOTO_TIMESTAMP_AK_LOCAL = @photo_ts_ak; -- not necessary?? filenames should be unique?

			IF @mand_err_count > 200 OR @opt_err_count > 500	-- Arbitrary values
				BREAK;

			SET @has_mand_error = 0;

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

		SET @Num_Recs = @opt_err_count + @mand_err_count;
		return 0;
	END TRY BEGIN CATCH
		SET @Error_Code = @@ERROR;
		SET @Num_Recs = @opt_err_count + @mand_err_count;
		return error_number()
	END CATCH
END
GO


