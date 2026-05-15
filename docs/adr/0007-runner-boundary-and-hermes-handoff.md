# Runner Boundary And Hermes Handoff

Status: Accepted

## Context

ADLC planning can produce PRDs, vertical slices, and agent briefs, but a sprint full of PRDs needs a durable execution queue when it should be built, reviewed, fixed, verified, and committed by multiple agents.

Hermes Kanban is well suited to that execution role because it persists tasks, comments, dependencies, workspaces, worker attempts, and human-in-loop blocked states. ADLC should not duplicate that runtime. ADLC should instead prepare clean sprint materials that Hermes can execute.

## Decision

ADLC separates sprint readiness from runner execution:

- `adlc-sprint` packages multiple PRDs, slices, or briefs into a runner-ready sprint folder.
- `adlc-hermes` adapts that sprint package to Hermes Kanban by verifying local profiles, writing a handoff, and optionally seeding tasks when explicitly requested.

Planning ends when the sprint package and runner handoff are complete. Hermes owns durable sprint execution.

## Consequences

The planning skills now have a clean end state before implementation: a sprint package with normalized work items, dependency graph, verification policy, release posture, and a Hermes handoff when requested.

Hermes-specific commands, profile discovery, and board seeding stay in the adapter skill instead of leaking into `adlc-plan`, `adlc-shape`, or `adlc-slice`.
