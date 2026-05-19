---
name: adlc-implement
description: Execute ADLC plans with Codex coordinators, bounded workers, and read-only sidecars.
---

# ADLC Implement

Use this to execute an existing plan or fix plan.

## Process

1. Locate the plan. Support explicit path, task number, `status`, or current branch.
2. Read `.adlc/skill-context/` before fallback patch history.
3. Use `implement-coordinator` when native Codex agents are available.
4. Keep tightly coupled work local in the coordinator.
5. Delegate independent bounded edits to `implement-worker` with disjoint write scopes.
6. Run read-only sidecars after meaningful code changes: review, security, rules, docs, best-practices, and commit-preparer as relevant.
7. Integrate worker results, rerun verification, and update plan task status.

## Rules

- Do not exceed the selected task scope.
- Do not let sidecars edit files.
- Do not call work complete without verification and a final integration state.

## Output

Report completed tasks, changed files, verification, sidecar findings, residual risk, and the next command: `adlc-verify`, `adlc-review`, `adlc-commit`, or `adlc-fix`.
