/*
	The CAMERA and FLOWN BY fields were added starting with the 2022 surveys,
	but this information was available for the 2017-2019 surveys, so this query
	simply updates the 2017-2019 data for completeness.
*/

select distinct
datepart(year, PHOTO_TIMESTAMP_AK_LOCAL)
--, CAMERA_SYSTEM   
, c.ID
, c.MAKE + ' ' + c.MODEL
--FROM [SEAN_Staging_2017].[SO].[view_SO_D_allrecs_w_lookups]
from [so].[SO_D] s
left join [so].[CAMERA] c on s.CAMERA_ID = c.ID
group by PHOTO_TIMESTAMP_AK_LOCAL
--, CAMERA_SYSTEM
, c.ID
, c.MAKE, c.MODEL

/*
update [so].[SO_D]
set CAMERA_ID = 2
where datepart(year, photo_timestamp_ak_local) < 2022
*/

select distinct
datepart(year, PHOTO_TIMESTAMP_AK_LOCAL)
, s.FLOWN_BY_ID
, e.INITIALS
--FROM [SEAN_Staging_2017].[SO].[view_SO_D_allrecs_w_lookups]
from [so].[SO_D] s
left join [so].[EMPLOYEE] e on s.FLOWN_BY_ID = e.ID
group by PHOTO_TIMESTAMP_AK_LOCAL
, s.FLOWN_BY_ID
, e.INITIALS

/*
update [so].[SO_D]
set FLOWN_BY_ID = 2
where datepart(year, photo_timestamp_ak_local) < 2022
*/
