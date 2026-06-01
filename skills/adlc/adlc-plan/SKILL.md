---
name: adlc-plan
description: Create executable ADLC plans with task graphs, acceptance criteria, and commit checkpoints.
---

# ADLC Plan

Use this to convert a clear request into an executable plan.

## Modes

- `fast`: one small task or quick fix; write `.adlc/PLAN.md`.
- `full`: larger feature or single-sprint multi-step change; write `.adlc/plans/<slug>.md`.
- `parallel`: only when tasks are independent enough for worktrees or Codex workers.
- `workstream`: when an epic needs Codex goal-managed milestones, durable step cards, and multi-sprint state; use `adlc-workstream`.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read configured ADLC context and repo guidance.
3. Run repo reconnaissance before asking questions.
4. Use `plan-coordinator` and `plan-polisher` when native Codex agents are available and the plan is non-trivial.
5. Choose the correct granularity: fast plan, full plan, parallel plan, roadmap item, or goal-managed workstream.
6. Define tasks with ownership, execution lane, dependencies, write scope, acceptance criteria, verification, docs/release impact, rollback notes when relevant, and commit checkpoints.
7. Split broad tasks until each task can be reviewed, verified, and committed as one coherent slice.
8. For 5 or more tasks, multiple milestones, or any long-running epic, create or update an `adlc-workstream`.
9. Mark blocked human decisions explicitly instead of hiding them inside implementation tasks.

## Output

Write or return the plan path, task graph, granularity choice, verification policy, commit policy, open gates, and whether it is ready for `adlc-improve`, `adlc-workstream`, or `adlc-implement`.
