-- B2 - fn_years_of_service
-- Returns completed years between the hire date and today.

CREATE OR REPLACE FUNCTION fn_years_of_service (
    p_hire_date IN DATE
) RETURN NUMBER
IS
    v_years NUMBER;
BEGIN
    IF p_hire_date IS NULL OR p_hire_date > SYSDATE THEN
        RETURN 0;
    END IF;

    -- MONTHS_BETWEEN is leap-year safe, unlike dividing a day count by 365
    v_years := TRUNC(MONTHS_BETWEEN(SYSDATE, p_hire_date) / 12);

    RETURN v_years;
END fn_years_of_service;
/
SHOW ERRORS
