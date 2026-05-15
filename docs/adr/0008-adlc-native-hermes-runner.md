# ADLC Native Hermes Runner

Status: Accepted

## Context

Early Hermes sprint runs used a private `sprint-runner` skill from the Metamodern skill repo to normalize sprint materials and seed Kanban tasks. That proved the workflow, but it left ADLC dependent on a private runner skill for public ADLC sprint execution.

ADLC now has the right lifecycle split:

- `adlc-sprint` packages sprint materials.
- `adlc-hermes` adapts the sprint package to Hermes Kanban.
- ADLC phase skills own build, audit, close, prove, release, and handoff gates.

The remaining useful runner behavior is generic setup, manifest discovery, execution topology guidance, deterministic graph seeding, and profile configuration.

## Decision

ADLC owns Hermes sprint setup and seeding directly.

New ADLC Hermes runs must not require the retired `sprint-runner` skill. New packages use `adlc-sprint.yaml` as the canonical manifest, with `sprint-runner.yaml` accepted only as a legacy alias for older sprint packages.

The ADLC repo provides:

- sprint material discovery and normalization guidance in `adlc-sprint`
- execution architecture guidance in `adlc-sprint`
- profile setup in `scripts/setup-hermes-adlc-profiles.sh`
- deterministic or orchestrator-mode seeding in `scripts/seed-adlc-hermes-sprint.sh`
- Hermes phase mapping in `adlc-hermes`

## Consequences

ADLC can package and seed Hermes sprints without the Metamodern skill repo being present.

Existing boards may continue to reference historical `sprint-runner` tasks until those boards are done or archived. Retiring live symlinks should wait until no active board depends on them.

Future runner improvements should land in ADLC unless they are project-private seed scripts that belong beside the project plan, not in the public skill suite.
