-- B3 - fn_calculate_tax
-- Progressive tax on annual income. Each rate applies only to the
-- part of the income that falls inside its own band.
--   up to 1,200,000          0%
--   1,200,001 to 3,600,000  10%
--   3,600,001 to 9,600,000  20%
--   above 9,600,000         30%

CREATE OR REPLACE FUNCTION fn_calculate_tax (
    p_annual_income IN NUMBER
) RETURN NUMBER
IS
    c_band1 CONSTANT NUMBER := 1200000;
    c_band2 CONSTANT NUMBER := 3600000;
    c_band3 CONSTANT NUMBER := 9600000;
    v_tax            NUMBER := 0;
BEGIN
    IF p_annual_income IS NULL OR p_annual_income <= 0 THEN
        RETURN 0;
    END IF;

    v_tax := CASE
                WHEN p_annual_income <= c_band1 THEN
                    0
                WHEN p_annual_income <= c_band2 THEN
                    (p_annual_income - c_band1) * 0.10
                WHEN p_annual_income <= c_band3 THEN
                    (c_band2 - c_band1) * 0.10
                  + (p_annual_income - c_band2) * 0.20
                ELSE
                    (c_band2 - c_band1) * 0.10
                  + (c_band3 - c_band2) * 0.20
                  + (p_annual_income - c_band3) * 0.30
             END;

    RETURN ROUND(v_tax, 2);
END fn_calculate_tax;
/
SHOW ERRORS
