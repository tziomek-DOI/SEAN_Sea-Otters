
		DECLARE
	--	@DST_Start smalldatetime
	--	,@DST_End smalldatetime
	--	,@time_zone nvarchar(6)
	--,@Counted_Date datetime
	--,@Protocol nvarchar(20)
	@Survey_Type varchar(1) = 'O'
	--,@Survey_Year int

	--	-- Extract the year, then get the start/end dates for that year:
	--	set @DST_Start = (SELECT dbo.fn_GetDaylightSavingsTimeStart(CONVERT(varchar,@Survey_Year)))
	--	set @DST_End = (SELECT dbo.fn_GetDaylightSavingsTimeEnd(CONVERT(varchar,@Survey_Year)))


		SELECT 
			s.photo_timestamp,
			s.SURVEY_TYPE,
			s.ImageID,
			CONCAT('SO_C_',DATEPART(year, s.PHOTO_TIMESTAMP),RIGHT('0' + RTRIM(MONTH(s.PHOTO_TIMESTAMP)),2),RIGHT('0' + RTRIM(DAY(s.PHOTO_TIMESTAMP)),2),'_',SUBSTRING(s.SURVEY_TYPE,1,1),
			'_', RIGHT('00000' + RTRIM(s.ImageID),5), '.JPG') AS PHOTO_FILE_NAME
			,FORMAT(s.PHOTO_TIMESTAMP, 'yyyy-MM-dd HH:mm:ss') -- SeeOtter should be UTC by default
			,SUBSTRING(s.FilePath, PATINDEX('%%\[01]_[0]_[0]_%%', s.FilePath)+1,LEN(s.FilePath)-PATINDEX('%%\[01]_[0]_[0]_%%', s.FilePath)) AS original_filename
		
			-- We could assume all Sea Otter surveys will be conducted during Daylight Savings Time months, but we'll program for it just in the hopes DST gets abolished someday!
			--,CASE WHEN s.PHOTO_TIMESTAMP BETWEEN @DST_Start AND @DST_End THEN CAST(s.PHOTO_TIMESTAMP AT TIME ZONE 'UTC' AT TIME ZONE 'UTC-08' AS datetime) --AS [UTC-to-AKDT]
			--	ELSE CAST(s.PHOTO_TIMESTAMP AT TIME ZONE 'UTC' AT TIME ZONE 'UTC-09' AS datetime) --AS [UTC-to-AKST]
			--	END
			--,s.LATITUDE_WGS84
			--,s.LONGITUDE_WGS84
			--,s.ALTITUDE
			--,(SELECT st.ID FROM [SO].[SURVEY_TYPE] st WHERE st.SURVEY_TYPE = s.SURVEY_TYPE) --AS SURVEY_TYPE_ID
			--,s.COUNT_ADULT
			--,s.COUNT_PUP
			----,s.KELP_PRESENT_ID
			----,s.LAND_PRESENT_ID
			--,(SELECT i.ID FROM [SO].[IMAGE_QUALITY] i WHERE i.IMAGE_QUALITY = s.IMAGE_QUALITY) --AS IMAGE_QUALITY_ID
			--,(SELECT e.ID FROM [SO].[EMPLOYEE] e WHERE e.AFFILIATION = s.SeeOtter_VERSION) --AS COUNTED_BY_ID
			---- COUNTED_DATE:
			---- Check the PHOTO_TIMESTAMP year and survey type. Update COUNTED_DATE only for matching records:
			--,CASE
			--	WHEN DATEPART(year, s.PHOTO_TIMESTAMP) = @Survey_Year AND @Survey_Type = SUBSTRING(s.SURVEY_TYPE,1,1) THEN @Counted_Date
			--END
			---- Protocol will also be an input param from a stored proc.
			--,(SELECT p.ID FROM [SEAN].tbl_protocol p WHERE p.protocol = @Protocol) --AS PROTOCOL_ID
			--,(SELECT q.ID FROM [SO].[QUALITY_FLAG] q WHERE q.QUALITY_FLAG = 'Raw') --AS QUALITY_FLAG_ID
			--,SUBSTRING(s.FilePath, PATINDEX('%%\[01]_[0]_[0]_%%', s.FilePath)+1,LEN(s.FilePath)-PATINDEX('%%\[01]_[0]_[0]_%%', s.FilePath)) --AS original_filename
			--,(SELECT e.ID FROM [SO].[EMPLOYEE] e WHERE e.INITIALS = s.FLOWN_BY) --AS FLOWN_BY_ID
			--,(SELECT c.ID FROM [SO].[CAMERA] c WHERE c.DESCRIPTION = s.CAMERA_SYSTEM) --AS CAMERA_ID
			--,CASE
			--	WHEN (s.Transect IS NULL OR TRIM(s.Transect) = '') THEN 'NA'
			--	ELSE s.Transect
			--END -- AS TRANSECT
			--,(SELECT e.ID FROM [SO].[EMPLOYEE] e WHERE e.INITIALS = s.VALIDATED_BY) --AS VALIDATED_BY_ID
			--,GETDATE()
			--,6
			--,GETDATE()
			--,6
		FROM [SO].[SO_D_SeeOtter] s
		WHERE SUBSTRING(s.SURVEY_TYPE,1,1) = @Survey_Type;
--		order by 