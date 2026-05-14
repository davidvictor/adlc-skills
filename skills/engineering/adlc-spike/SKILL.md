---
name: adlc-spike
description: Build a throwaway prototype that answers one design, state, logic, or UI question before committing to an implementation. Use when the user wants to prototype, explore variants, test a state model, sanity-check an interface, or make an uncertainty concrete.
---

# ADLC Spike

A spike is throwaway code that answers one question.

## Pick The Branch

Choose the branch based on the question:

- **Logic spike**: state machine, business rules, data shape, API feel, edge-case behavior. Use [LOGIC.md](./LOGIC.md).
- **UI spike**: layout, information hierarchy, interaction model, visual variants. Use [UI.md](./UI.md).

If the question is ambiguous and the user is present, ask. If not, choose the branch that best matches the surrounding code and state your assumption.

## Rules

- State the question before writing code.
- Keep it clearly marked as a spike.
- Use one command to run.
- Use in-memory state by default.
- Do not add tests unless the spike is being promoted into real code.
- Do not wire real production mutations.
- Capture the answer when done.
- Delete the spike or fold the validated decision into production code.
- If the spike becomes production work, switch to `adlc-build`.

## Durable Output

The spike code is disposable. The answer is not.

When complete, record:

- the question
- what the spike taught us
- the decision made
- what should be deleted or absorbed
- whether an ADR, PRD update, or issue draft should follow

## Closeout

Report the run command, the observed answer, the winning direction if any, and the cleanup or promotion path.
