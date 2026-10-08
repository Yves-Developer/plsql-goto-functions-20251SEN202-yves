-- A4 - Rewrite Without GOTO
-- The A2 salary review expressed with structured control flow.

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Version 1: IF / ELSIF / ELSE

DECLARE
    v_employee_name VARCHAR2(50) := 'Bob Nkurunziza';
    v_salary        NUMBER       := 520000;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Reviewing ' || v_employee_name || ' at ' || v_salary);

    IF v_salary < 200000 THEN
        DBMS_OUTPUT.PUT_LINE('Salary below the minimum band, raise required');
    ELSIF v_salary < 600000 THEN
        DBMS_OUTPUT.PUT_LINE('Salary in the middle band, review recommended');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Salary is competitive, no action');
    END IF;
END;
/

-- Version 2: the same rules as a CASE expression

DECLARE
    v_employee_name VARCHAR2(50) := 'Bob Nkurunziza';
    v_salary        NUMBER       := 520000;
    v_decision      VARCHAR2(100);
BEGIN
    v_decision := CASE
                     WHEN v_salary < 200000 THEN 'raise required'
                     WHEN v_salary < 600000 THEN 'review recommended'
                     ELSE 'no action'
                  END;

    DBMS_OUTPUT.PUT_LINE(v_employee_name || ': ' || v_decision);
END;
/
