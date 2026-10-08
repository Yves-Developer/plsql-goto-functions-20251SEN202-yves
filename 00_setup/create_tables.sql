-- Assignment III - setup
-- Creates the DEPARTMENTS and EMPLOYEES tables used by all tasks.

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Drop existing objects so this script can be re-run
BEGIN
    FOR t IN (SELECT table_name FROM user_tables
              WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

CREATE TABLE departments (
    department_id   NUMBER(4)    PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL,
    location        VARCHAR2(50)
);

CREATE TABLE employees (
    employee_id   NUMBER(6)    PRIMARY KEY,
    first_name    VARCHAR2(30) NOT NULL,
    last_name     VARCHAR2(30) NOT NULL,
    hire_date     DATE,
    salary        NUMBER(10,2),
    department_id NUMBER(4)
);

INSERT INTO departments VALUES (10, 'Head Office',     'Kigali');
INSERT INTO departments VALUES (20, 'Human Resources', 'Kigali');
INSERT INTO departments VALUES (30, 'Engineering',     'Huye');
INSERT INTO departments VALUES (40, 'Sales',           'Musanze');

-- Salaries are monthly. Rows 10 to 12 are deliberately invalid so that
-- C1_fn_validate_payroll has failure cases to report.
INSERT INTO employees VALUES ( 1, 'Alice',    'Mukamana',       DATE '2015-03-01',  850000, 10);
INSERT INTO employees VALUES ( 2, 'Bob',      'Nkurunziza',     DATE '2018-07-15',  520000, 30);
INSERT INTO employees VALUES ( 3, 'Claire',   'Uwase',          DATE '2020-01-10',  310000, 20);
INSERT INTO employees VALUES ( 4, 'David',    'Habimana',       DATE '2012-09-01', 1200000, 10);
INSERT INTO employees VALUES ( 5, 'Eric',     'Ndayisaba',      DATE '2022-06-01',  180000, 30);
INSERT INTO employees VALUES ( 6, 'Fiona',    'Kamikazi',       DATE '2023-11-20',   95000, 40);
INSERT INTO employees VALUES ( 7, 'Gilbert',  'Rwema',          DATE '2019-04-05',  640000, 30);
INSERT INTO employees VALUES ( 8, 'Honorine', 'Mutesi',         DATE '2021-02-14',  420000, 20);
INSERT INTO employees VALUES ( 9, 'Isaac',    'Bizimana',       DATE '2016-10-01',  730000, 40);
INSERT INTO employees VALUES (10, 'Jeanne',   'Nyirahabimana',  DATE '2024-01-08',  260000, NULL);
INSERT INTO employees VALUES (11, 'Kevin',    'Shema',          DATE '2026-12-31',  300000, 30);
INSERT INTO employees VALUES (12, 'Linda',    'Ingabire',       DATE '2023-05-02',   50000, 40);

COMMIT;

-- Row count check: expect 4 departments and 12 employees
SELECT 'departments' AS table_name, COUNT(*) AS row_count FROM departments
UNION ALL
SELECT 'employees',                 COUNT(*)              FROM employees;
