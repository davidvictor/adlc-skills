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

## Process

1. Read `.adlc/` context and repo guidance.
2. Run repo reconnaissance before asking questions.
3. Use `plan-coordinator` and `plan-polisher` when native Codex agents are available and the plan is non-trivial.
4. Define tasks with ownership, dependencies, acceptance criteria, verification, and commit checkpoints.
5. For 5 or more tasks, include a commit plan.
6. Mark blocked human decisions explicitly instead of hiding them inside implementation tasks.

## Output

Write or return the plan path, task graph, verification policy, commit policy, open gates, and whether it is ready for `adlc-improve` or `adlc-implement`.
