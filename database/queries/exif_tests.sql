/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
--TOP (1) 
[ID]
      ,[PHOTO_FILENAME]
      ,[SURVEY_YEAR]
      ,[SURVEY_TYPE]
	  ,EXIF_PHOTO_DATE
      ,FORMAT([EXIF_PHOTO_DATE], 'yyyy-MM-dd HH:mm') as EXIF_PHOTO_DATE_FMT
      ,[NOTES]
  FROM [SEAN_Staging_2017].[SO].[SO_C_PHOTO_INFO]

select top 1 *
from [SO].[SO_D]
where datepart(year, photo_timestamp_ak_local) = 2022

--IF FORMAT(CONVERT(datetime, '2022-08-03 22:40:00.000'), 'yyyy-MM-dd HH:mm') != (SELECT TOP 1 FORMAT([EXIF_PHOTO_DATE], 'yyyy-MM-dd HH:mm') FROM [SO].[SO_C_PHOTO_INFO] WHERE PHOTO_FILENAME = '0_000_00_001.jpg')
IF (SELECT COUNT(PHOTO_FILE_NAME) FROM [SO].[SO_D] WHERE DATEPART(year, PHOTO_TIMESTAMP_AK_LOCAL) = 2022 AND SUBSTRING(PHOTO_FILE_NAME, 15, 1) = 'O') != 
(SELECT COUNT(PHOTO_FILENAME) FROM [SO].[SO_C_PHOTO_INFO] WHERE DATEPART(year, EXIF_PHOTO_DATE) = 2022 AND SURVEY_TYPE = 'Optimal')
select 'ne'
else
select 'eq'

select FORMAT(CONVERT(datetime, '2022-08-03 22:40:00.000'), 'yyyy-MM-dd HH:mm')
(SELECT TOP 1 FORMAT([EXIF_PHOTO_DATE], 'yyyy-MM-dd HH:mm') FROM [SO].[SO_C_PHOTO_INFO] WHERE PHOTO_FILENAME = '0_000_00_001.jpg')