SELECT 
    CASE
       WHEN B.Gender IS NULL THEN 'non-binary'
       WHEN B.Gender = '' THEN 'LGBTIQ'
       ELSE B.Gender
  END AS  Gender,
  CASE 
    WHEN B.Race IS NULL OR  B.Race = 'None' THEN 'Mixed'
    ELSE B.Race
  END AS Race,
  CASE
        WHEN B.Age BETWEEN 0 AND 17 THEN 'Kids'
        WHEN B.Age BETWEEN 18 AND 24 THEN 'Youth'
        WHEN B.Age BETWEEN 25 AND 34 THEN 'Young_adults'
        WHEN B.Age BETWEEN 35 AND 44 THEN 'Adults'
        WHEN B.Age BETWEEN 45 AND 54 THEN 'Matured'
        WHEN B.Age BETWEEN 55 AND 64 THEN 'pensioner'
        ELSE 'Old'
      END AS Age_Bucket,
    CASE   
        WHEN B.Province IS NULL THEN 'Other'
        WHEN B.Province = 'None' THEN 'Not Specified'
        ELSE B.Province 
    END AS Province,
  from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg') AS LocalDateTime,
  IFNULL (A.Channel2, 'Not_Viewing') AS Channel,
   CASE 
      WHEN A.RecordDate2 IS NULL THEN DATE '2016-03-31'
      ELSE TO_DATE(TIMESTAMP(A.RecordDate2))
    END AS The_Date,
    CASE 
     WHEN A.RecordDate2 IS NULL THEN DATE_FORMAT(CURRENT_TIMESTAMP() + INTERVAL '2 hour', 
     'HH:mm:ss') 
     ELSE DATE_FORMAT (A.RecordDate2 + INTERVAL '2 HOUR', 'HH:mm:ss')
     END AS SA_time,
    CASE
        WHEN HOUR(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) BETWEEN 0 AND 5 THEN '01. EarlyMorning'
        WHEN HOUR(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) BETWEEN 6 AND 9 THEN '02. Morning'
        WHEN HOUR(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) BETWEEN 10 AND 11 THEN '03. LateMorning'
        WHEN HOUR(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) BETWEEN 12 AND 16 THEN '04. Afternoon'
        WHEN HOUR(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) BETWEEN 17 AND 19 THEN '05. Evening'
        WHEN HOUR(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) BETWEEN 20 AND 23 THEN '06. Night'
    END AS Time_Bucket,
    DATE_FORMAT(A.`Duration 2`, 'HH:mm:ss') AS duration,
   CASE 
      WHEN A.`Duration 2` BETWEEN '00:00:00' AND '00:30:00' THEN '30MIN'
      WHEN A.`Duration 2` BETWEEN '00:31:00' AND '00:59:59' THEN '1HOUR'
      WHEN A.`Duration 2` BETWEEN '01:00:00' AND '01:30:00' THEN '2H30'
      WHEN A.`Duration 2` BETWEEN '02:00:00' AND '02:59:59' THEN '30MIN'
      ELSE '5H+'
  END AS Duration_Bucket

FROM workspace.default.bright_tv_viewership AS A
FULL JOIN workspace.default.bright_tv_user_profile AS B
ON B.userID = A.userID0
