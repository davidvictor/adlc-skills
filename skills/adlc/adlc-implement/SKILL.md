---
name: adlc-implement
description: Execute ADLC plans with Codex coordinators, bounded workers, and read-only sidecars.
---

# ADLC Implement

Use this to execute an existing plan or fix plan.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Locate the plan. Support explicit path, task number, `status`, or current branch.
3. Read any interview spec cited by the plan or workstream before editing.
4. If executing a workstream step, read `WORKSTREAM.md`, `kanban.md`, the relevant milestone card, and the selected step card before editing.
5. For goal-managed workstreams, check the active Codex goal at the start and preserve the goal objective through closeout.
6. Read configured skill-context before fallback patch history.
7. Use `implement-coordinator` when native Codex agents are available.
8. Keep tightly coupled work local in the coordinator.
9. Delegate independent bounded edits to `implement-worker` with disjoint write scopes.
10. Run read-only sidecars after meaningful code changes: review, security, rules, docs, best-practices, and commit-preparer as relevant.
11. Integrate worker results, rerun verification, and update plan, milestone, or workstream step status.

## Rules

- Do not exceed the selected task scope.
- Do not cross interview non-goals or decision boundaries without recording the blocker.
- Do not advance a workstream step past `commit` until the committed slice is explicit.
- Do not mark a Codex goal complete until the whole workstream objective is achieved.
- Do not let sidecars edit files.
- Do not call work complete without verification and a final integration state.

## Output

Report completed tasks, changed files, verification, sidecar findings, residual risk, workstream or goal status when relevant, and the next command: `adlc-verify`, `adlc-review`, `adlc-commit`, or `adlc-fix`.
