-- A2 - Salary Review
-- Decides the review action for one salary using GOTO.

SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
    v_employee_name VARCHAR2(50) := 'Bob Nkurunziza';
    v_salary        NUMBER       := 520000;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Reviewing ' || v_employee_name || ' at ' || v_salary);

    IF v_salary < 200000 THEN
        GOTO raise_required;
    ELSIF v_salary < 600000 THEN
        GOTO review_recommended;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Salary is competitive, no action');
    GOTO review_done;

<<raise_required>>
    DBMS_OUTPUT.PUT_LINE('Salary below the minimum band, raise required');
    GOTO review_done;

<<review_recommended>>
    DBMS_OUTPUT.PUT_LINE('Salary in the middle band, review recommended');

-- NULL is a real statement and gives this closing label something to point at
<<review_done>>
    NULL;
END;
/
