# PL/SQL GOTO Statements and Functions – Individual Assignment III

| Field | Details |
|---|---|
| **Student Name** | MUGISHA Yves |
| **Student ID** | 20251SEN202 |
| **Course** | Database Development with PL/SQL (INSY 8311) |
| **Instructor** | Eric Maniraguha |
| **Assignment Date** | Thursday, October 1, 2026 |
| **Deadline** | Thursday, October 8, 2026, 11:59 PM |
| **Database** | Oracle Database 21c Express Edition, 21.3.0.0.0 |

---

## Overview

This assignment covers unconditional branching with `GOTO`, stored functions,
exception handling, and calling your own functions from SQL. Part A uses
`GOTO` and then removes it. Part B builds four functions over an employee
payroll schema and calls them from a `SELECT`. Part C combines both into a
validation function that reports why a payroll record is wrong.

| # | Task | File |
|---|---|---|
| A1 | Number Classifier | `01_goto/A1_number_classifier.sql` |
| A2 | Salary Review | `01_goto/A2_salary_review.sql` |
| A3 | Illegal GOTO and Fix | `01_goto/A3_illegal_goto.sql` |
| A4 | Rewrite Without GOTO | `01_goto/A4_rewrite_no_goto.sql` |
| B1 | Annual Salary | `02_functions/B1_fn_annual_salary.sql` |
| B2 | Years of Service | `02_functions/B2_fn_years_of_service.sql` |
| B3 | Tax Calculator | `02_functions/B3_fn_calculate_tax.sql` |
| B4 | Department Name | `02_functions/B4_fn_dept_name.sql` |
| B5 | Functions in SQL | `03_tests/B5_functions_in_select.sql` |
| C1 | Payroll Validator | `02_functions/C1_fn_validate_payroll.sql` |
| C2 | Reflection | `docs/REFLECTION.md` |

---

## Repository Structure

```
plsql-goto-functions-20251SEN202-yves/
├── README.md
├── .gitignore
├── 00_setup/
│   └── create_tables.sql
├── 01_goto/
│   ├── A1_number_classifier.sql
│   ├── A2_salary_review.sql
│   ├── A3_illegal_goto.sql
│   └── A4_rewrite_no_goto.sql
├── 02_functions/
│   ├── B1_fn_annual_salary.sql
│   ├── B2_fn_years_of_service.sql
│   ├── B3_fn_calculate_tax.sql
│   ├── B4_fn_dept_name.sql
│   └── C1_fn_validate_payroll.sql
├── 03_tests/
│   ├── B5_functions_in_select.sql
│   ├── test_functions.sql
│   └── test_validate_payroll.sql
├── screenshots/
│   ├── A1_output.png
│   ├── A2_output.png
│   ├── A3_error_and_fix.png
│   ├── A4_output.png
│   ├── B5_select_output.png
│   └── C1_output.png
└── docs/
    └── REFLECTION.md
```

---

## How to Run

Run `SET SERVEROUTPUT ON` first, otherwise `DBMS_OUTPUT.PUT_LINE` writes to a
buffer you never see. Each script already sets it.

```sql
@00_setup/create_tables.sql

@02_functions/B1_fn_annual_salary.sql
@02_functions/B2_fn_years_of_service.sql
@02_functions/B3_fn_calculate_tax.sql
@02_functions/B4_fn_dept_name.sql
@02_functions/C1_fn_validate_payroll.sql

@01_goto/A1_number_classifier.sql
@01_goto/A2_salary_review.sql
@01_goto/A3_illegal_goto.sql
@01_goto/A4_rewrite_no_goto.sql

@03_tests/B5_functions_in_select.sql
@03_tests/test_functions.sql
@03_tests/test_validate_payroll.sql
```

The functions must be compiled before the test files, because `B5` and
`C1` call them. `C1_fn_validate_payroll` calls all four Part B functions, so
it is compiled last.

---

## Database Design

Two tables. Salaries are stored **monthly**; the annual figure is derived by
`fn_annual_salary`.

**departments**

| Column | Type | Notes |
|---|---|---|
| department_id | NUMBER(4) | primary key |
| department_name | VARCHAR2(50) | not null |
| location | VARCHAR2(50) | |

**employees**

| Column | Type | Notes |
|---|---|---|
| employee_id | NUMBER(6) | primary key |
| first_name, last_name | VARCHAR2(30) | not null |
| hire_date | DATE | |
| salary | NUMBER(10,2) | monthly |
| department_id | NUMBER(4) | nullable |

There are 4 departments and 12 employees. Employees 1 to 9 are ordinary
records. The last three are deliberately invalid so that the Part C validator
has real failures to report, and no `CHECK` constraints are declared on
`employees` for the same reason:

| ID | Employee | Problem | Caught by |
|---|---|---|---|
| 10 | Jeanne Nyirahabimana | `department_id` is NULL | `unknown_department` |
| 11 | Kevin Shema | hire date 2026-12-31 is in the future | `hire_date_in_future` |
| 12 | Linda Ingabire | salary 50,000 is below the 60,000 minimum | `salary_too_low` |

---

## Part A – GOTO

`GOTO` transfers control unconditionally to a label written as `<<label>>`.
Two rules drive everything in Part A:

1. A label must stand immediately before an **executable statement** or a
   nested block. A label cannot be the last thing in a block, which is why
   `NULL;` appears after `<<review_done>>` in A2 — `NULL;` is a real no-op
   statement that gives the label a target.
2. A `GOTO` may branch **out of** an `IF` or a loop, but never **into** one,
   never from one `IF` branch across to another, never out of a subprogram,
   and never between a block's executable section and its `EXCEPTION` section.

### A1 – Number Classifier

Classifies `v_number` as negative, zero or positive. The `IF` sends control to
`<<negative_number>>` or `<<zero_number>>`; falling through both tests means
the number is positive, and each branch ends by jumping to
`<<classification_done>>` so the other branches cannot run. Change the
initial value of `v_number` to test the other two paths.

![A1 output](screenshots/A1_output.png)

### A2 – Salary Review

The same fall-through pattern applied to salary bands: below 200,000 a raise
is required, below 600,000 a review is recommended, otherwise no action. This
is the file that demonstrates the mandatory `NULL;` after the closing label.

![A2 output](screenshots/A2_output.png)

### A3 – Illegal GOTO and Fix

Part 1 of the file tries to jump into the middle of a `FOR` loop from outside
it. The compiler rejects it with `PLS-00201: identifier 'INSIDE_LOOP' must be
declared`. The reason is scope, not syntax: a label written inside a loop body
is not visible outside that loop, so the `GOTO` cannot resolve the name at
all. That invisibility is exactly why a `GOTO` can never branch into a loop.
The failure is at compile time, so the block never executes and no `i = ...`
line is printed.

Part 2 keeps the same intent — skip the detail lines — but moves the label
*after* the loop, so control jumps around the loop rather than into it. That
is a legal forward jump and the block compiles and runs.

![A3 error and fix](screenshots/A3_error_and_fix.png)

### A4 – Rewrite Without GOTO

A2 rewritten twice: once as `IF / ELSIF / ELSE`, once as a `CASE` expression
assigned to a variable. Both produce the same output as A2. The structured
versions are shorter, every branch has one entry and one exit, and no label
or jump has to be traced to see which lines can execute. The `CASE` version
goes further by separating the decision from the printing, so the rule could
be reused without duplicating the output statement.

![A4 output](screenshots/A4_output.png)

---

## Part B – Functions

A function declares its return type in the header and returns a value in the
body. The space between `IS` and `BEGIN` is the declaration section, so there
is no `DECLARE` keyword. `SHOW ERRORS` follows every `CREATE OR REPLACE`,
because Oracle reports `Function created with compilation errors` as a warning
and leaves a broken function in place rather than failing.

### B1 – `fn_annual_salary(p_monthly_salary) RETURN NUMBER`

Multiplies a monthly salary by 12. The guard clause returning 0 for `NULL` or
negative input is there so that **every path returns a value** — a path with
no `RETURN` compiles cleanly and then fails at run time with
`ORA-06503: PL/SQL: Function returned without value`.

### B2 – `fn_years_of_service(p_hire_date) RETURN NUMBER`

`TRUNC(MONTHS_BETWEEN(SYSDATE, p_hire_date) / 12)`. `MONTHS_BETWEEN` is used
rather than `(SYSDATE - p_hire_date) / 365`, which drifts by a day every leap
year. `TRUNC` gives completed years, so an employee of 4 years 11 months
counts as 4. A `NULL` or future hire date returns 0; the future date is
reported as an error by C1 instead, which keeps each function to one job.

### B3 – `fn_calculate_tax(p_annual_income) RETURN NUMBER`

Progressive tax on **annual** income. Each rate applies only to the slice of
income inside its own band, which is how real income tax works — not a single
rate applied to the whole salary.

| Annual income | Rate on that slice |
|---|---|
| up to 1,200,000 | 0% |
| 1,200,001 – 3,600,000 | 10% |
| 3,600,001 – 9,600,000 | 20% |
| above 9,600,000 | 30% |

Worked example, Alice at 850,000 monthly = 10,200,000 annual:
`0` + `10% × 2,400,000` + `20% × 6,000,000` + `30% × 600,000` = **1,620,000**.

### B4 – `fn_dept_name(p_department_id) RETURN VARCHAR2`

A `SELECT INTO` lookup, and the one function that needs an `EXCEPTION` block.
`SELECT INTO` does not return an empty result when nothing matches — it raises
`NO_DATA_FOUND`, and raises `TOO_MANY_ROWS` if more than one row matches.
Both are handled so that a bad `department_id` returns a readable label
instead of aborting the surrounding query. The column is declared with
`departments.department_name%TYPE` so it cannot drift from the table.

### B5 – Functions in SQL

`03_tests/B5_functions_in_select.sql` calls all four functions from a
`SELECT`, including one nested call —
`fn_calculate_tax(fn_annual_salary(e.salary))` — and then uses them in
`WHERE`, `GROUP BY` and `ORDER BY` to show they behave like built-in
functions.

Two constraints apply to a function used from SQL: it must return a **SQL**
datatype, so `BOOLEAN` is not allowed, and it must not perform DML. Both
shaped the design of C1.

![B5 select output](screenshots/B5_select_output.png)

---

## Part C – Combined

### C1 – `fn_validate_payroll(p_employee_id) RETURN VARCHAR2`

Reads one employee, applies three business rules, and returns either a `VALID`
line with the derived figures or an `INVALID` line naming the reason. It calls
all four Part B functions, so it is the integration test for the whole
assignment.

It returns `VARCHAR2`, not `BOOLEAN`, for the reason given in B5 — a
`BOOLEAN` function cannot be called from a `SELECT`, and
`test_validate_payroll.sql` does exactly that.

Error handling uses both kinds of exception taught in the course:

- **User-defined**, declared in the header and raised with `RAISE` when a rule
  fails: `salary_too_low`, `hire_date_in_future`, `unknown_department`.
- **Predefined**: `NO_DATA_FOUND`, for an `employee_id` that does not exist.
- **`WHEN OTHERS` with `SQLERRM`** as a catch-all, so an unexpected error is
  reported rather than escaping into the calling query.

Raising a named exception rather than returning a string at each check keeps
the happy path readable: the body reads as three guards and one `RETURN`, and
all the message text lives in the `EXCEPTION` block.

![C1 output](screenshots/C1_output.png)

### C2 – Reflection

See [`docs/REFLECTION.md`](docs/REFLECTION.md), which answers when `GOTO` is
justified, how each `GOTO` pattern maps to a structured replacement, and why a
`GOTO` cannot cross into or out of an `EXCEPTION` block.

---

## Challenges Encountered

**A label cannot end a block.** My first version of A2 ended with
`<<review_done>>` immediately before `END;` and would not compile. A label
must precede an executable statement, so the closing label needs `NULL;`
after it. This is why every `GOTO` example ends that way rather than as a
matter of style.

**A function can compile and still be broken.** `CREATE OR REPLACE FUNCTION`
reports compilation errors as a *warning* and leaves the invalid function in
the schema, so the next script appears to work until the function is called.
Adding `SHOW ERRORS` after every create made the failures visible immediately.

**`SELECT INTO` raises instead of returning nothing.** `fn_dept_name` returned
no rows for employee 10, whose `department_id` is NULL, and the error
propagated out and killed the whole `SELECT` in B5 rather than affecting that
one row. Handling `NO_DATA_FOUND` and adding the NULL guard fixed it, and it
is the clearest difference I met between PL/SQL and plain SQL.

---

## Notes

**Use of an AI assistant.** I used an AI assistant while working on this
assignment, in the following ways:

- To explain PL/SQL concepts that are not in the course slides. Lecture 05
  covers `GOTO` on slides 66–69 and stored *procedures* in depth, but
  `CREATE FUNCTION` is not taught in either Lecture 04 or 05 — it appears only
  as a one-line bullet in the list of program units on Lecture 04 slide 30.
  I asked for the function syntax and the rules about using functions in SQL,
  then checked them against the Oracle documentation.
- To explain the restrictions on `GOTO` that produce the A3 error, and why a
  label needs `NULL;` after it.
- To review my code for the bugs described under Challenges above.

I wrote and executed every script myself, all screenshots come from my own
Oracle instance, and I can explain and defend every line of the submitted
code.

---

## Submission

```
Repository: https://github.com/Yves-Developer/plsql-goto-functions-20251SEN202-yves
Visibility: Public
Submitted via: Google Form
```
