-- B4 - fn_dept_name
-- Looks up a department name and handles the lookup failures.

CREATE OR REPLACE FUNCTION fn_dept_name (
    p_department_id IN NUMBER
) RETURN VARCHAR2
IS
    v_department_name departments.department_name%TYPE;
BEGIN
    IF p_department_id IS NULL THEN
        RETURN 'Not Assigned';
    END IF;

    SELECT department_name
    INTO   v_department_name
    FROM   departments
    WHERE  department_id = p_department_id;

    RETURN v_department_name;
EXCEPTION
    -- SELECT INTO raises these two instead of returning an empty result
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown Department';
    WHEN TOO_MANY_ROWS THEN
        RETURN 'Ambiguous Department';
END fn_dept_name;
/
SHOW ERRORS
