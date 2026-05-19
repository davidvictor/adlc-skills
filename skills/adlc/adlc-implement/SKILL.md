---
name: adlc-implement
description: Execute ADLC plans with Codex coordinators, bounded workers, and read-only sidecars.
---

# ADLC Implement

Use this to execute an existing plan or fix plan.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Locate the plan. Support explicit path, task number, `status`, or current branch.
3. If executing a workstream step, read `WORKSTREAM.md`, `kanban.md`, and the selected step card before editing.
4. Read configured skill-context before fallback patch history.
5. Use `implement-coordinator` when native Codex agents are available.
6. Keep tightly coupled work local in the coordinator.
7. Delegate independent bounded edits to `implement-worker` with disjoint write scopes.
8. Run read-only sidecars after meaningful code changes: review, security, rules, docs, best-practices, and commit-preparer as relevant.
9. Integrate worker results, rerun verification, and update plan or workstream step status.

## Rules

- Do not exceed the selected task scope.
- Do not advance a workstream step past `commit` until the committed slice is explicit.
- Do not let sidecars edit files.
- Do not call work complete without verification and a final integration state.

## Output

Report completed tasks, changed files, verification, sidecar findings, residual risk, and the next command: `adlc-verify`, `adlc-review`, `adlc-commit`, or `adlc-fix`.
