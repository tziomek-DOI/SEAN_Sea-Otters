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
	@Survey_Year int
	,@Num_Recs int OUTPUT
	,@Error_Code int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		-- Declare variables to store the fields for each fetch
		DECLARE
		@photo_file_name	NVARCHAR(30)
		,@photo_ts_utc		DATETIME
		,@photo_ts_ak		DATETIME
		,@latitude			DECIMAL(10,8)
		,@longitude			DECIMAL(11,8)
		,@altitude			INT
		,@survey_type		NVARCHAR(9)
		,@count_adult		INT
		,@count_pup			INT
		,@kelp_present		NVARCHAR(3)
		,@land_present		NVARCHAR(3)
		,@image_quality		NVARCHAR(8)
		,@counted_by		NVARCHAR(100) -- will be initials for humans, or the SeeOtter version
		,@counted_date		DATE
		,@protocol			NVARCHAR(10)
		,@quality_flag		NVARCHAR(255)

		-- Create a cursor to interate the SO_D table, filtered by the survey year parameter
		DECLARE sod_cursor CURSOR FOR
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
		,f.INITIALS
		,c.

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

		OPEN sod_cursor;
		FETCH NEXT FROM sod_cursor 
		INTO --var list (need to declare);
		@photo_file_name
		;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Do stuff

			FETCH NEXT FROM sod_cursor
			INTO --var list;
			@photo_file_name
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
