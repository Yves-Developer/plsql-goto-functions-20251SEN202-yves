-- A3 - Illegal GOTO and Fix
-- Part 1 fails to compile, Part 2 is the corrected version.

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Part 1: illegal. A label inside a loop body is not visible outside the
-- loop, so this GOTO cannot resolve <<inside_loop>> and the block fails
-- to compile.

DECLARE
    v_total NUMBER := 0;
BEGIN
    GOTO inside_loop;

    FOR i IN 1 .. 3 LOOP
<<inside_loop>>
        v_total := v_total + i;
        DBMS_OUTPUT.PUT_LINE('i = ' || i);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total = ' || v_total);
END;
/

-- Part 2: fix. The label is moved after the loop, so the GOTO jumps
-- around the loop instead of into it.

DECLARE
    v_total       NUMBER  := 0;
    v_skip_detail BOOLEAN := TRUE;
BEGIN
    IF v_skip_detail THEN
        GOTO after_loop;
    END IF;

    FOR i IN 1 .. 3 LOOP
        v_total := v_total + i;
        DBMS_OUTPUT.PUT_LINE('i = ' || i);
    END LOOP;

<<after_loop>>
    DBMS_OUTPUT.PUT_LINE('Detail skipped, total = ' || v_total);
END;
/
