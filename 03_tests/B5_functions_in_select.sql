-- B5 - Functions in SQL
-- Calls the Part B functions from a SELECT statement.

SET LINESIZE 200
SET PAGESIZE 60

COLUMN employee_name FORMAT A22
COLUMN department    FORMAT A18

SELECT e.employee_id,
       e.first_name || ' ' || e.last_name            AS employee_name,
       e.salary                                      AS monthly_salary,
       fn_annual_salary(e.salary)                    AS annual_salary,
       fn_years_of_service(e.hire_date)              AS years_of_service,
       fn_calculate_tax(fn_annual_salary(e.salary))  AS annual_tax,
       fn_dept_name(e.department_id)                 AS department
FROM   employees e
ORDER BY e.employee_id;

-- Functions also work in WHERE, GROUP BY and ORDER BY
SELECT fn_dept_name(e.department_id)      AS department,
       COUNT(*)                           AS staff_count,
       SUM(fn_annual_salary(e.salary))    AS annual_payroll
FROM   employees e
WHERE  fn_years_of_service(e.hire_date) >= 3
GROUP BY fn_dept_name(e.department_id)
ORDER BY annual_payroll DESC;
