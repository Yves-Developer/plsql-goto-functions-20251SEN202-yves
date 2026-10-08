-- Tests for C1_fn_validate_payroll.
-- Employees 10, 11 and 12 are the three deliberate failure cases.

SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 200
SET PAGESIZE 60

COLUMN employee_name     FORMAT A22
COLUMN validation_result FORMAT A95

DECLARE
    v_result VARCHAR2(400);
BEGIN
    FOR r IN (SELECT employee_id FROM employees ORDER BY employee_id) LOOP
        v_result := fn_validate_payroll(r.employee_id);
        DBMS_OUTPUT.PUT_LINE(v_result);
    END LOOP;

    -- An ID that does not exist, handled by NO_DATA_FOUND
    DBMS_OUTPUT.PUT_LINE(fn_validate_payroll(99));
END;
/

-- The same validation returned as a result set
SELECT employee_id,
       first_name || ' ' || last_name    AS employee_name,
       fn_validate_payroll(employee_id)  AS validation_result
FROM   employees
ORDER BY employee_id;
