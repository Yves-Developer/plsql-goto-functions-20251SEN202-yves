-- C1 - fn_validate_payroll
-- Validates one employee's payroll record and returns a status line.
-- Returns VARCHAR2 rather than BOOLEAN so it can be called from SQL.
-- Requires B1, B2, B3 and B4 to be compiled first.

CREATE OR REPLACE FUNCTION fn_validate_payroll (
    p_employee_id IN NUMBER
) RETURN VARCHAR2
IS
    c_minimum_salary CONSTANT NUMBER := 60000;

    v_first_name    employees.first_name%TYPE;
    v_salary        employees.salary%TYPE;
    v_hire_date     employees.hire_date%TYPE;
    v_department_id employees.department_id%TYPE;
    v_dept_name     VARCHAR2(50);

    salary_too_low      EXCEPTION;
    hire_date_in_future EXCEPTION;
    unknown_department  EXCEPTION;
BEGIN
    SELECT first_name, salary, hire_date, department_id
    INTO   v_first_name, v_salary, v_hire_date, v_department_id
    FROM   employees
    WHERE  employee_id = p_employee_id;

    IF v_salary IS NULL OR v_salary < c_minimum_salary THEN
        RAISE salary_too_low;
    END IF;

    IF v_hire_date IS NULL OR v_hire_date > SYSDATE THEN
        RAISE hire_date_in_future;
    END IF;

    v_dept_name := fn_dept_name(v_department_id);

    IF v_dept_name IN ('Not Assigned', 'Unknown Department') THEN
        RAISE unknown_department;
    END IF;

    RETURN 'VALID: ' || v_first_name
           || ' | dept ' || v_dept_name
           || ' | annual ' || fn_annual_salary(v_salary)
           || ' | tax ' || fn_calculate_tax(fn_annual_salary(v_salary))
           || ' | service ' || fn_years_of_service(v_hire_date) || 'y';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'INVALID: no employee with ID ' || p_employee_id;
    WHEN salary_too_low THEN
        RETURN 'INVALID: ' || v_first_name
               || ' salary ' || NVL(TO_CHAR(v_salary), 'NULL')
               || ' is below the minimum of ' || c_minimum_salary;
    WHEN hire_date_in_future THEN
        RETURN 'INVALID: ' || v_first_name || ' has a missing or future hire date';
    WHEN unknown_department THEN
        RETURN 'INVALID: ' || v_first_name || ' is not in a valid department';
    WHEN OTHERS THEN
        RETURN 'ERROR: ' || SQLERRM;
END fn_validate_payroll;
/
SHOW ERRORS
