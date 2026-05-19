---
name: adlc-plan
description: Create fast or full implementation plans with task graphs and commit checkpoints.
---

# ADLC Plan

Use this to convert a clear request into an executable plan.

## Modes

- `fast`: one small task or quick fix; write `.adlc/PLAN.md`.
- `full`: larger feature or multi-step change; write `.adlc/plans/<slug>.md`.
- `parallel`: only when tasks are independent enough for worktrees or Codex workers.
- `workstream`: when an epic needs durable step cards and staged Codex or Hermes handoff; use `adlc-workstream`.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read configured ADLC context and repo guidance.
3. Run repo reconnaissance before asking questions.
4. Use `plan-coordinator` and `plan-polisher` when native Codex agents are available and the plan is non-trivial.
5. Define tasks with ownership, dependencies, acceptance criteria, verification, and commit checkpoints.
6. For 5 or more tasks or any long-running epic, decide whether the scope should become an `adlc-workstream`.
7. Mark blocked human decisions explicitly instead of hiding them inside implementation tasks.

## Output

Write or return the plan path, task graph, verification policy, commit policy, open gates, and whether it is ready for `adlc-improve` or `adlc-implement`.
