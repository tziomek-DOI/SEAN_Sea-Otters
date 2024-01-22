/*
 * Load the pre-2022 SO_D records from the production database into the new SO_D table.
 * SO_D contains two datetime columns to store the PHOTO_TIMESTAMP; one for UTC and one for AK local time.
 * The pre-2022 data is in AK local. Although it's ideal to code dynamically, since this is a one-time
 * data load and all data is in DST, we can avoid the complexity this time.
 */
use [SEAN_Staging_TEST_2017]
GO

BEGIN
    -- Insert statements for procedure here
	INSERT INTO [SEAN_Staging_TEST_2017].[SO].[SO_D]
	(PHOTO_FILE_NAME,PHOTO_TIMESTAMP_UTC,PHOTO_TIMESTAMP_AK_Local,LATITUDE_WGS84,LONGITUDE_WGS84,ALTITUDE,SURVEY_TYPE_ID,COUNT_ADULT,COUNT_PUP,KELP_PRESENT_ID,LAND_PRESENT_ID,IMAGE_QUALITY_ID,
	COUNTED_BY_ID,COUNTED_DATE,PROTOCOL_ID,QUALITY_FLAG_ID,TRANSECT,DATE_CREATED,CREATED_BY_ID,DATE_LAST_UPDATED,LAST_UPDATED_BY_ID)
	SELECT 
		s.PHOTO_FILE_NAME
		-- load into the UTC column:
		,CAST(s.PHOTO_TIMESTAMP AT TIME ZONE 'UTC-08' AT TIME ZONE 'UTC' AS datetime)
		-- load into the AK_Local column
		,s.PHOTO_TIMESTAMP
		,s.LATITUDE_WGS84
		,s.LONGITUDE_WGS84
		,s.ALTITUDE
		,s.SURVEY_TYPE_ID
		,s.COUNT_ADULT
		,s.COUNT_PUP
		,s.KELP_PRESENT_ID
		,s.LAND_PRESENT_ID
		,s.IMAGE_QUALITY_ID
		,s.COUNTED_BY_ID
		,s.COUNTED_DATE
		,s.PROTOCOL_ID
		,s.QUALITY_FLAG_ID
		,'NA' -- new field for 2022 data, backfilled instead of null/blank
		,GETDATE()
		,6
		,GETDATE()
		,6
	FROM [SEAN_Staging_TEST_2017].[SO].[SO_D_2019] s
/*
	VALUES
	(@PhotoFileName,@PhotoTimeStamp,@Lat,@Long,@Altitude,@SurveyTypeID,@CountAdult,@CountPup,@KelpPresentID,@LandPresentID,@ImageQualityID,@CountedByID,@CountedDate,
	@ProtocolID,@QualityFlagID,@MarkedForDeletion,@OriginalFilename,@FlownByID,@CameraID,@ValidatedByID)
	SET @Identity = SCOPE_IDENTITY()
*/
END