-- A1 - Number Classifier
-- Classifies a number as negative, zero or positive using GOTO.

SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
    v_number NUMBER := -15;
BEGIN
    IF v_number < 0 THEN
        GOTO negative_number;
    ELSIF v_number = 0 THEN
        GOTO zero_number;
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_number || ' is POSITIVE');
    GOTO classification_done;

<<negative_number>>
    DBMS_OUTPUT.PUT_LINE(v_number || ' is NEGATIVE');
    GOTO classification_done;

<<zero_number>>
    DBMS_OUTPUT.PUT_LINE(v_number || ' is ZERO');

-- A label must sit in front of an executable statement
<<classification_done>>
    DBMS_OUTPUT.PUT_LINE('Classification complete');
END;
/
