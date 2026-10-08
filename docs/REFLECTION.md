# Reflection – C2

**MUGISHA Yves — 20251SEN202**

## When is GOTO justified in PL/SQL?

Rarely, and only where structured control flow would be worse. The cases I
would accept are:

- Jumping forward to a single clean-up or exit label from several different
  error checks, where the alternative is deeply nested `IF` statements.
- Breaking out of nested loops at once. PL/SQL's `EXIT` leaves only the loop
  it is in, so without labelled loops a `GOTO` to a label after the outermost
  loop is shorter than carrying a flag variable.
- Jumping from an exception handler back to a label in an enclosing block to
  retry or continue processing.

In every one of these the jump goes *forward* and *out*. A backward `GOTO`
that builds a loop by hand, like the lecture's `<<start_loop>>` example, is
never justified now that `LOOP`, `WHILE` and `FOR` exist.

## How can you replace GOTO with structured control flow?

Each `GOTO` pattern has a direct replacement:

| GOTO pattern | Structured replacement |
|---|---|
| Jump to one of several labels that each print a result | `IF / ELSIF / ELSE`, or a `CASE` expression assigned to a variable |
| Backward jump to repeat a section | `WHILE` loop, or `FOR` when the number of iterations is known |
| Forward jump to skip the rest of a loop body | `CONTINUE` |
| Forward jump to leave a loop early | `EXIT WHEN` |
| Jump to an error label on a failed check | declare an exception, `RAISE` it, handle it in the `EXCEPTION` block |

A4 shows the first of these: the three labels of A2 become three branches of
one `IF`, and then a single `CASE` expression. The structured version is
shorter, every branch has one entry and one exit, and the reader does not have
to trace jumps to work out which lines can run.

## What happens if a GOTO jumps over an EXCEPTION block?

It cannot. The executable section and the exception section of a block are two
separate regions, and a `GOTO` cannot cross between them:

- A `GOTO` in the executable section cannot target a label inside that block's
  own `EXCEPTION` section. The only way into an exception handler is for an
  exception to be raised.
- A `GOTO` inside an exception handler cannot jump back into the executable
  section of the same block. It may only target a label in an *enclosing*
  block.

Either attempt is rejected at compile time as an illegal `GOTO`, not at run
time. The practical consequence is that `GOTO` cannot be used to skip error
handling or to resume a block after an error. Control reaches a handler only
through a raised exception, and once the handler finishes, the block ends.

## What I took away

Coming from Java and C++, the constructs that actually needed attention were
not `GOTO` but the small PL/SQL-specific rules around it: a label has to stand
in front of an executable statement, which is why `NULL;` exists; and a
function that compiles is not a function that works, because a missing
`RETURN` on one path only shows up at run time as `ORA-06503`. Writing B4
taught me the most, because `SELECT INTO` raising `NO_DATA_FOUND` instead of
returning nothing is the opposite of how a query behaves in plain SQL.
