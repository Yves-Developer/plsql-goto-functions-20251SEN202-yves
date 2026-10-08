-- Unit tests for the Part B functions.
-- Each column uses a known input so the output can be checked by hand.

SET LINESIZE 200
SET PAGESIZE 60

COLUMN existing_id FORMAT A20
COLUMN missing_id  FORMAT A20
COLUMN null_id     FORMAT A20

-- B1: expect 6000000, 0, 0
SELECT fn_annual_salary(500000) AS from_500k,
       fn_annual_salary(0)      AS from_zero,
       fn_annual_salary(NULL)   AS from_null
FROM dual;

-- B2: expect a positive number, 0, 0
SELECT fn_years_of_service(DATE '2015-03-01') AS hired_2015,
       fn_years_of_service(SYSDATE)           AS hired_today,
       fn_years_of_service(DATE '2026-12-31') AS hired_in_future
FROM dual;

-- B3: expect 0, 96000, 264000, 2880000
SELECT fn_calculate_tax(1140000)  AS band_0,
       fn_calculate_tax(2160000)  AS band_10,
       fn_calculate_tax(3720000)  AS band_20,
       fn_calculate_tax(14400000) AS band_30
FROM dual;

-- B4: expect Engineering, Unknown Department, Not Assigned
SELECT fn_dept_name(30)   AS existing_id,
       fn_dept_name(99)   AS missing_id,
       fn_dept_name(NULL) AS null_id
FROM dual;
