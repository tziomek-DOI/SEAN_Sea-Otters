select datepart(year, photo_timestamp_ak_local), QUALITY_FLAG_ID, count(quality_Flag_id) AS CNT, q.DEFINITION, q.DESCRIPTION
from SO.SO_D s
inner join SO.QUALITY_FLAG q ON s.QUALITY_FLAG_ID = q.ID
group by datepart(year, photo_timestamp_ak_local), QUALITY_FLAG_ID, q.DEFINITION, q.DESCRIPTION
order by datepart(year, photo_timestamp_ak_local), QUALITY_FLAG_ID
