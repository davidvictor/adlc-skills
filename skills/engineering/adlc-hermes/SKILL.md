---
name: adlc-hermes
description: Prepare and optionally seed Hermes Kanban from an ADLC sprint package, preserving build, review, fix, verification, and publication gates.
---

# ADLC Hermes

Hand an ADLC sprint to Hermes without losing the lifecycle gates.

Use this when the user wants Hermes to run, manage, seed, or monitor a sprint prepared by ADLC. This skill is a runner adapter: planning should already be shaped into a sprint package by `adlc-sprint`.

## Process

1. Read the sprint package, especially `sprint-runner.yaml`, `work-items/`, and `handoff.md`.
2. If no sprint package exists, use `adlc-sprint` first.
3. Verify the local Hermes setup using [HERMES-HANDOFF.md](./HERMES-HANDOFF.md).
4. Discover real Hermes profiles before assigning work.
5. Check whether the Hermes `sprint-runner`, `kanban-orchestrator`, and `kanban-worker` skills are available.
6. Choose a board, orchestrator profile, worker profiles, workspace mode, and notification mode.
7. Write or update `hermes-handoff.md` inside the sprint package.
8. Seed Hermes Kanban only when the user explicitly asks to create tasks or run the sprint.
9. After seeding, report task ids, board name, watch commands, and any blocked items.

## Rules

- Do not invent Hermes profile names. Use discovered profiles or ask for the profile map.
- Do not seed execution tasks for HITL items unless the task is explicitly a decision/blocker task.
- Do not treat Hermes as the planning source of truth. ADLC owns planning artifacts; Hermes owns durable execution state.
- Prefer Hermes Kanban for sprint execution. Use `delegate_task` only for short bounded subtasks inside a worker.
- Preserve the gates: build, self-verify, hostile review, review fixes, final verify, commit or publish.
- Prefer `worktree` workspaces for isolated code work and `dir:<absolute path>` only when shared state is intentional.
- Keep human decisions durable through Kanban comments and blocked state.

## Output Contract

Produce:

- Hermes setup verdict
- selected board and profile map
- sprint package path
- handoff file path
- seed command or created task ids
- watch and recovery commands
- blocked decisions and residual risks

If Hermes is not available, still produce a complete handoff file and exact commands for the operator to run later.

## Closeout

Report:

- whether the sprint was only prepared or actually seeded
- which Hermes board and profiles were used
- which ADLC items map to which Hermes tasks
- how to watch progress
- what would block Hermes from completing the sprint
