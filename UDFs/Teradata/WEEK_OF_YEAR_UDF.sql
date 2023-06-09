-- <copyright file="WEEK_OF_YEAR_UDF.sql" company="Mobilize.Net">
--        Copyright (C) Mobilize.Net info@mobilize.net - All Rights Reserved
-- 
--        This file is part of the Mobilize Frameworks, which is
--        proprietary and confidential.
-- 
--        NOTICE:  All information contained herein is, and remains
--        the property of Mobilize.Net Corporation.
--        The intellectual and technical concepts contained herein are
--        proprietary to Mobilize.Net Corporation and may be covered
--        by U.S. Patents, and are protected by trade secret or copyright law.
--        Dissemination of this information or reproduction of this material
--        is strictly forbidden unless prior written permission is obtained
--        from Mobilize.Net Corporation.
-- </copyright>

-- ======================================================================
-- RETURNS WHICH "FULL WEEK" OF THE YEAR A DATE BELONGS TO, 
-- EQUIVALENT TO THE TD_WEEK_OF_YEAR AND WEEKNUMBER_OF_YEAR FUNCTION FROM TERADATA
-- TERADATA CONSIDERS THE FIRST WEEK OF THE YEAR TO BE 0 IF IT IS "NOT FULL" (DOES NOT START WITH SUNDAY)
-- THIS MEANS THAT THE "FULL WEEK" COUNT STARTS FROM THE WEEK THAT HAS THE FIRST SUNDAY OF THE YEAR
-- PARAMETERS:
--      INPUT: TIMESTAMP_TZ. DATE TO GET THE NUMBER OF WEEK FROM
-- RETURNS:
--      A NUMBER THAT REPRESENTS THE WEEK NUMBER THE DATE BELONGS TO
-- EXAMPLE:
--  SELECT PUBLIC.WEEK_OF_YEAR_UDF(DATE '2024-05-10'),
--  PUBLIC.WEEK_OF_YEAR_UDF(DATE '2020-01-03')
-- RETURNS 18, 0
--
-- EQUIVALENT: TERADATA'S WEEKNUMBER_OF_YEAR AND TD_WEEK_OF_YEAR FUNCTIONALITY
-- EXAMPLE:
--  SELECT TD_WEEK_OF_YEAR (DATE '2024-05-10'),
--  WEEKNUMBER_OF_YEAR (DATE '2020-01-03');
-- RETURNS 18, 0
-- ======================================================================
CREATE OR REPLACE FUNCTION PUBLIC.WEEK_OF_YEAR_UDF(INPUT TIMESTAMP_TZ)
RETURNS NUMBER
IMMUTABLE
AS
$$
    TRUNC((dayofyear(INPUT)-mod((datediff('d','1900-01-01',INPUT)+1),7)+6)/7)
$$;

-- ======================================================================
-- RETURNS THE DAY OF THE WEEK A TIMESTAMP BELONGS TO, 
-- HAS THE SAME BEHAVIOR AS THE DAYNUMBER_OF_WEEK(DATE, 'COMPATIBLE') FUNCTION
-- WITH COMPATIBLE CALENDAR FROM TERADATA,FIRST DAY OF THE WEEK WILL BE THE SAME
-- DAY AS THE DAY OF THE FIRST OF JANUARY
-- PARAMETERS:
--      INPUT: TIMESTAMP_TZ. DATE TO GET THE DAY OF WEEK FROM
-- RETURNS:
--      AN INTEGER BETWEEN 1 AND 7 WHERE  IF JANUARY FIRST IS WEDNESDAY
--      1 = WEDNESDAY, 2 = THURSDAY, ..., 7 = TUESDAY
--
-- EXAMPLE:
--  SELECT PUBLIC.DAY_OF_WEEK_COMPATIBLE_UDF(DATE '2022-01-01'),
--  PUBLIC.DAY_OF_WEEK_COMPATIBLE_UDF(DATE '2023-05-05');
-- RETURNS 1, 6
--
-- EQUIVALENT: TERADATA'S DAYNUMBER_OF_WEEK FUNCTIONALITY
-- EXAMPLE:
--  SELECT DAYNUMBER_OF_WEEK (DATE '2022-01-01', 'COMPATIBLE'),
--  DAYNUMBER_OF_WEEK (DATE '2023-05-05', 'COMPATIBLE');
-- RETURNS 1, 6
-- ======================================================================
CREATE OR REPLACE FUNCTION PUBLIC.DAY_OF_WEEK_COMPATIBLE_UDF(INPUT TIMESTAMP_TZ)
RETURNS INT
LANGUAGE SQL
IMMUTABLE
AS
$$
  IFF(DAYOFWEEKISO(INPUT)=DAYOFWEEKISO(date_from_parts(year(INPUT),1,1)),1,DAYOFWEEKISO(DATEADD(DAY,-DAYOFWEEKISO(date_from_parts(year(INPUT)-1,12,31)),INPUT)))

$$;

-- ======================================================================
-- RETURNS WHICH WEEK OF THE YEAR A DATE BELONGS TO, 
-- EQUIVALENT TO THE WEEKNUMBER_OF_YEAR(DATE, 'COMAPTIBLE') FUNCTION FROM TERADATA
-- ALWAYS START WITH WEEK ONE CAUSE THE FIRST DAY OF THE WEEK IT'S THE SAME DAY
-- OF FIRST OF JANUARY
-- PARAMETERS:
--      INPUT: TIMESTAMP_TZ. DATE TO GET THE NUMBER OF WEEK FROM
-- RETURNS:
--      A NUMBER THAT REPRESENTS THE WEEK NUMBER THE DATE BELONGS TO
-- EXAMPLE:
--  SELECT PUBLIC.WEEK_OF_YEAR_COMPATIBLE_UDF(DATE '2022-01-01'),
--  PUBLIC.WEEK_OF_YEAR_COMPATIBLE_UDF(DATE '2023-05-05');
-- RETURNS 1, 18
--
-- EQUIVALENT: TERADATA'S WEEKNUMBER_OF_YEAR FUNCTIONALITY
-- EXAMPLE:
--  SELECT WEEKNUMBER_OF_YEAR (DATE '2022-01-01', 'COMPATIBLE'),
--  WEEKNUMBER_OF_YEAR (DATE '2023-05-05', 'COMPATIBLE');
-- RETURNS 1, 18
-- ======================================================================
CREATE OR REPLACE FUNCTION PUBLIC.WEEK_OF_YEAR_COMPATIBLE_UDF(INPUT TIMESTAMP_LTZ)
RETURNS NUMBER
IMMUTABLE
AS
$$
     CASE 
     WHEN PUBLIC.WEEKNUMBER_OF_YEAR_UDF(INPUT) = 0 THEN 1
     WHEN PUBLIC.DAY_OF_WEEK_COMPATIBLE_UDF(INPUT) >= 5 THEN PUBLIC.WEEKNUMBER_OF_YEAR_UDF(DATEADD(day,DAYOFWEEKISO(INPUT)-4,INPUT))
     WHEN PUBLIC.DAY_OF_WEEK_COMPATIBLE_UDF(INPUT) < 5 THEN PUBLIC.WEEKNUMBER_OF_YEAR_UDF(DATEADD(day,7-DAYOFWEEKISO(INPUT),INPUT))
     END
$$;