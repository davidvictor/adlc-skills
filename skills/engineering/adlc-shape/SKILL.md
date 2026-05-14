---
name: adlc-shape
description: Turn resolved conversation context, codebase understanding, and decisions into an execution-ready PRD. Use when the user wants a PRD, spec, implementation contract, or product requirements from context already discussed.
---

# ADLC Shape

Shape resolved context into a PRD. Do not run a long interview here. If major decisions are unresolved, recommend `adlc-probe` or `adlc-anchor` first.

## Process

1. Read `docs/adlc/operating-contract.md`, if present.
2. Explore the repo if needed.
3. Use `CONTEXT.md` vocabulary when present.
4. Respect relevant ADRs.
5. Identify the main modules, interfaces, data contracts, UI states, and user-visible behavior.
6. Look for opportunities to make implementation testable through deep interfaces.
7. Name the intended feedback loop and release needs.
8. Write the PRD using [PRD-TEMPLATE.md](./PRD-TEMPLATE.md).

## Rules

- Prefer behavior and contracts over stale file paths.
- Avoid line numbers.
- Include code snippets only when they encode a precise decision, such as a state machine, type shape, schema, or protocol.
- Acceptance criteria must be testable.
- Include out-of-scope items.
- Include a verification plan.
- Include readiness criteria for `adlc-slice` and `adlc-build`.
- If the user asks for issues too, finish the PRD first, then use `adlc-slice`.

## Closeout

Tell the user:

- where the PRD was written, or provide the PRD in chat if no path was requested
- what is still unresolved
- whether it is ready for `adlc-slice`
