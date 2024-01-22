/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ImageID]
      ,[PHOTO_TIMESTAMP]
      ,[FilePath]
      ,[LATITUDE_WGS84]
      ,[LONGITUDE_WGS84]
      ,[ALTITUDE]
      ,[ImageCorner1Lat]
      ,[ImageCorner1Lon]
      ,[ImageCorner2Lat]
      ,[ImageCorner2Lon]
      ,[ImageCorner3Lat]
      ,[ImageCorner3Lon]
      ,[ImageCorner4Lat]
      ,[ImageCorner4Lon]
      ,[VALIDATED_BY]
      ,[COUNT_ADULT]
      ,[COUNT_PUP]
      ,[GSD]
      ,[Width_m]
      ,[Height_m]
      ,[Coverage_sqkm]
      ,[Transect]
      ,[FLOWN_BY]
      ,[SeeOtter_VERSION]
      ,[SURVEY_TYPE]
      ,[CAMERA_SYSTEM]
      ,[IMAGE_QUALITY]
 FROM [SEAN_Staging_TEST_2017].[SO].[SO_D_2022]
 order by PHOTO_TIMESTAMP desc

/*
select count(*)  FROM [SEAN_Staging_TEST_2017].[SO].[SO_D_2022]
5419 (O file)
16155 - all files - matches expected
*/
/*
truncate table [SEAN_Staging_TEST_2017].[SO].[SO_D_2022]

SELECT [start_time],[end_time],[status] FROM [SSISDB].[catalog].[executions] WHERE [execution_id]=53225
*/

