# Logic Spike

Use for business logic, state transitions, data models, and interface feel.

## Process

1. State the question in a top-of-file comment or adjacent notes file.
2. Use the host project's language and tooling.
3. Isolate the logic behind a small pure interface:
   - reducer
   - explicit state machine
   - pure functions over a data type
   - small module with clear methods
4. Build the thinnest terminal or CLI shell that lets the user drive scenarios.
5. Render the full relevant state after every action.
6. Add one command to run it.
7. Capture the answer.

## Anti-Patterns

- wiring to the real database unless persistence is the question
- mixing terminal UI with the logic being evaluated
- generalizing for future possibilities
- leaving the shell in production code
- claiming the spike is tested production behavior
