/****** 
 * The COUNTED_DATE is populated by reading the date created on the files.
 * However, for 2022 the TRANSECT column was only added via SeeOtter for the Random files,
 * and was then manually added to the A/O files, which changed the file date.
 * This update sets those dates to the actual counted date.
 ******/

/*
UPDATE [SEAN_Staging_2017].[SO].[SO_D]
SET counted_date = '2023-11-02'
  where datepart(year, PHOTO_TIMESTAMP_AK_LOCAL) = 2022
  and SUBSTRING(photo_file_name, 15, 1) = 'A'

UPDATE [SEAN_Staging_2017].[SO].[SO_D]
SET counted_date = '2023-11-03'
  where datepart(year, PHOTO_TIMESTAMP_AK_LOCAL) = 2022
  and SUBSTRING(photo_file_name, 15, 1) = 'O'
*/

SELECT 
      [PHOTO_FILE_NAME]
      ,[PHOTO_TIMESTAMP_UTC]
      ,[PHOTO_TIMESTAMP_AK_LOCAL]
      ,[LATITUDE_WGS84]
      ,[LONGITUDE_WGS84]
      ,[ALTITUDE]
      ,[SURVEY_TYPE_ID]
      ,[COUNT_ADULT]
      ,[COUNT_PUP]
      ,[KELP_PRESENT_ID]
      ,[LAND_PRESENT_ID]
      ,[IMAGE_QUALITY_ID]
      ,[COUNTED_BY_ID]
      ,[COUNTED_DATE]
      ,[PROTOCOL_ID]
      ,[QUALITY_FLAG_ID]
      ,[MARKED_FOR_DELETION]
      ,[ORIGINAL_FILENAME]
      ,[FLOWN_BY_ID]
      ,[CAMERA_ID]
      ,[TRANSECT]
      ,[VALIDATED_BY_ID]
      ,[DATE_CREATED]
      ,[CREATED_BY_ID]
      ,[DATE_LAST_UPDATED]
      ,[LAST_UPDATED_BY_ID]
  FROM [SEAN_Staging_2017].[SO].[SO_D]
  where datepart(year, PHOTO_TIMESTAMP_AK_LOCAL) = 2022
  order by PHOTO_TIMESTAMP_AK_LOCAL
--  and SUBSTRING(photo_file_name, 15, 1) = 'A'

