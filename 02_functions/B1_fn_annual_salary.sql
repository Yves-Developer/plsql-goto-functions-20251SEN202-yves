-- B1 - fn_annual_salary
-- Converts a monthly salary into an annual salary.

CREATE OR REPLACE FUNCTION fn_annual_salary (
    p_monthly_salary IN NUMBER
) RETURN NUMBER
IS
    v_annual_salary NUMBER;
BEGIN
    -- Guard clause so every path returns a value
    IF p_monthly_salary IS NULL OR p_monthly_salary < 0 THEN
        RETURN 0;
    END IF;

    v_annual_salary := p_monthly_salary * 12;

    RETURN v_annual_salary;
END fn_annual_salary;
/
SHOW ERRORS
