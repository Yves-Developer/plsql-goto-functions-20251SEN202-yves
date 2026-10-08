# Reflection – C2

**MUGISHA Yves — 20251SEN202**

## When is GOTO justified in PL/SQL?

Rarely. It is only reasonable where structured control flow would be worse,
and in practice that means three cases:

- Jumping forward to a single clean-up or exit label when several different
  checks all have to end the same way. The alternative is deeply nested `IF`
  statements.
- Leaving several nested loops at once. `EXIT` only leaves the loop it is in,
  so a jump to a label after the outermost loop is simpler than carrying a
  flag variable through each level.
- Jumping from an exception handler to a label in an enclosing block, to
  continue processing after an error.

In all three the jump goes *forward* and *outward*. A backward `GOTO` that
builds a loop by hand, like the `<<start_loop>>` example in the lecture, is
never justified now that `LOOP`, `WHILE` and `FOR` exist.

## How can you replace GOTO with structured control flow?

Each pattern has a direct replacement:

| GOTO pattern | Structured replacement |
|---|---|
| Jump to one of several labels that each print a result | `IF / ELSIF / ELSE`, or a `CASE` expression |
| Backward jump to repeat a section | `WHILE`, or `FOR` when the count is known |
| Forward jump to skip the rest of a loop body | `CONTINUE` |
| Forward jump to leave a loop early | `EXIT WHEN` |
| Jump to an error label after a failed check | declare an exception, `RAISE` it, handle it in the `EXCEPTION` block |

A4 shows the first of these. The three labels in A2 become three branches of
one `IF`, and then a single `CASE` expression. The structured version is
shorter, each branch has one entry and one exit, and the reader does not have
to follow jumps to see which lines can run.

## What happens if a GOTO jumps over an EXCEPTION block?

It cannot. The executable section and the exception section of a block are
separate regions, and a `GOTO` cannot cross between them:

- A `GOTO` in the executable section cannot target a label inside that block's
  own `EXCEPTION` section. The only way into a handler is for an exception to
  be raised.
- A `GOTO` inside an exception handler cannot jump back into the executable
  section of the same block. It may only target a label in an enclosing block.

Both attempts are rejected when the block is compiled, not while it runs. The
practical result is that `GOTO` cannot be used to skip error handling or to
restart a block after an error. Control reaches a handler only through a
raised exception, and when the handler finishes, the block ends.

## What I learned

The difficult part was not `GOTO` itself but the smaller PL/SQL rules around
it. A label must come before a real statement, which is why `NULL;` exists. A
function that compiles is not necessarily a function that works, because a
missing `RETURN` on one path only appears at run time as `ORA-06503`. Writing
B4 taught me the most: `SELECT INTO` raises `NO_DATA_FOUND` instead of
returning no rows, which is the opposite of how a query behaves in plain SQL,
and it is the reason that function needs an `EXCEPTION` block.
