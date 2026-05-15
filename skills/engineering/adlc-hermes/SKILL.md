---
name: adlc-hermes
description: Prepare and optionally seed Hermes Kanban from an ADLC sprint package, preserving build, review, fix, verification, and publication gates.
---

# ADLC Hermes

Hand an ADLC sprint to Hermes without losing the lifecycle gates.

Use this when the user wants Hermes to run, manage, seed, or monitor a sprint prepared by ADLC. This skill is a runner adapter: planning should already be shaped into a sprint package by `adlc-sprint`.

## Process

1. Read the sprint package, especially `adlc-sprint.yaml`, `work-items/`, and `handoff.md`. During migration, accept legacy `sprint-runner.yaml`.
2. If no sprint package exists, use `adlc-sprint` first.
3. Verify the local Hermes setup using [HERMES-HANDOFF.md](./HERMES-HANDOFF.md).
4. Verify the ADLC phase skills are available to Hermes using [HERMES-ADLC-PHASES.md](./HERMES-ADLC-PHASES.md).
5. Discover real Hermes profiles before assigning work.
6. Check whether the Hermes `kanban-orchestrator` and `kanban-worker` skills are available.
7. Run or mirror the healthcheck in [HERMES-HANDOFF.md](./HERMES-HANDOFF.md).
8. Choose a board, orchestrator profile, worker profiles, workspace mode, and notification mode.
9. Map sprint phases to ADLC skills: build, audit, close, prove, release, and handoff.
10. Write or update `hermes-handoff.md` inside the sprint package.
11. Seed Hermes Kanban only when the user explicitly asks to create tasks or run the sprint. Prefer a deterministic graph from the ADLC manifest when the package is complete; otherwise create one `adlc-hermes` orchestrator task.
12. After seeding, report task ids, board name, watch commands, and any blocked items.

## Rules

- Do not invent Hermes profile names. Use discovered profiles or ask for the profile map.
- Do not seed execution tasks for HITL items unless the task is explicitly a decision/blocker task.
- Do not treat Hermes as the planning source of truth. ADLC owns planning artifacts; Hermes owns durable execution state.
- Prefer Hermes Kanban for sprint execution. Use `delegate_task` only for short bounded subtasks inside a worker.
- Preserve the gates: build, self-verify, hostile review, review fixes, final verify, commit or publish.
- Load the relevant `adlc-*` skill on each Hermes worker task when it is installed.
- Prefer `worktree` workspaces for isolated code work and `dir:<absolute path>` only when shared state is intentional.
- Keep human decisions durable through Kanban comments and blocked state.
- Treat ordinary phase gates as completions, not blockers: build completes into audit, audit completes into close/prove, and close completes into proof or handoff.
- Use blocked state only for human decisions, missing credentials or environment, destructive approval, unsafe scope expansion, or verification that cannot reach a useful verdict.
- Do not require or seed the legacy `sprint-runner` skill for new ADLC Hermes runs.

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
