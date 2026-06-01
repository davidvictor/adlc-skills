---
id: {{WORKSTREAM_ID}}-codex-goal-handoff
type: handoff
status: active
owner: ADLC
documents: [{{WORKSTREAM_ID}}]
---

# Codex Goal Workstream Handoff

Use `adlc-implement` for one step at a time unless the workstream explicitly marks steps as independent and parallelizable. Keep the active Codex goal aligned with the workstream objective while detailed state stays in ADLC artifacts.

## Prompt Shape

```text
Execute ADLC workstream step <step-id> from <path>.

Continue the Codex goal recorded in WORKSTREAM.md.
Follow the step write scope exactly.
Move through build -> review -> fix -> test -> commit.
Update the step card, milestone card, and kanban state before closeout.
Report verification, review findings, commit status, blockers, goal status, and next runnable step.
```

## Execution Rules

- Read `WORKSTREAM.md`, `kanban.md`, the relevant milestone card, and the selected step card first.
- Use `get_goal` on resume. Create a goal only when the user request or workstream explicitly calls for goal-managed execution.
- Use Codex workers only for independent bounded write scopes.
- Run read-only sidecars before commit readiness.
- Use `update_goal` only when the whole workstream objective is complete or the same blocker satisfies the tool's blocked policy.
- Do not advance the next step until the current step is committed or explicitly blocked.
