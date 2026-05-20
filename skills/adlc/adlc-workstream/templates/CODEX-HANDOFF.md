---
id: {{WORKSTREAM_ID}}-codex-handoff
type: handoff
status: active
owner: ADLC
documents: [{{WORKSTREAM_ID}}]
---

# Codex Workstream Handoff

Use `adlc-implement` for one step at a time unless the workstream explicitly marks steps as independent and parallelizable.

## Prompt Shape

```text
Execute ADLC workstream step <step-id> from <path>.

Follow the step write scope exactly.
Move through build -> review -> fix -> test -> commit.
Update the step card and kanban state before closeout.
Report verification, review findings, commit status, blockers, and next runnable step.
```

## Execution Rules

- Read `WORKSTREAM.md`, `kanban.md`, and the selected step card first.
- Use Codex workers only for independent bounded write scopes.
- Run read-only sidecars before commit readiness.
- Do not advance the next step until the current step is committed or explicitly blocked.
