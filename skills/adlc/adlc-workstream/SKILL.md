---
name: adlc-workstream
description: Plan grounded long-running workstreams with staged Codex or Hermes handoffs.
---

# ADLC Workstream

Use this when an epic is too large for one plan execution pass and needs durable step cards, Kanban state, and executor handoffs.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Ground the epic in live repo evidence, existing plans, architecture, rules, and user constraints before creating steps.
3. Create or update `paths.workstreams/<slug>/` with a workstream overview, Kanban board, step cards, and executor handoffs.
4. Break the epic into independent steps that can move through `build -> review -> test -> commit`.
5. Assign each step an executor lane: `codex`, `hermes`, or `either`.
6. For Codex handoff, include the exact ADLC plan/step path, bounded write scope, verification commands, and expected gate outputs.
7. For Hermes handoff, create a Kanban-ready card contract that Hermes can import into its own board without losing ADLC artifact IDs.
8. Keep blocked decisions explicit and avoid inventing dependencies that are not supported by evidence.

## Rules

- Workstreams coordinate execution; they do not replace `adlc-plan`, `adlc-implement`, `adlc-verify`, `adlc-review`, or `adlc-commit`.
- Every step must have evidence, scope, acceptance criteria, verification, commit checkpoint, and next-stage rules.
- Hermes owns its own Kanban once a card is handed off; ADLC owns the source workstream artifact and exported handoff contract.
- Do not create Hermes-specific runners or hidden automation. ADLC exports work; executors perform it through their normal lifecycle.
- Long-running state must live in files, not chat memory.

## Output

Report the workstream root, step count, executor lanes, blocked decisions, current Kanban state, and the next runnable step for Codex or Hermes.
