---
id: adlc-adr-0003-workstreams
type: adr
status: accepted
owner: ADLC
---

# ADR 0003: Workstreams Manage Long-Running Epics

Status: accepted

## Context

Some scopes are too large for a single ADLC plan or one Codex session. Recent Hermes usage also needs a clean handoff shape: Hermes maintains its own Kanban, but the source scope still needs ADLC grounding, step boundaries, and lifecycle gates.

## Decision

ADLC adds `adlc-workstream` and `adlc workstream` as the durable epic-planning surface.

Workstreams live under `paths.workstreams`, default `.adlc/workstreams/`. A workstream contains an overview, evidence, Kanban state, step cards, and Codex/Hermes handoff files.

Every step moves through:

```text
ready -> build -> review -> test -> commit -> done
```

`blocked` is available whenever an executor cannot proceed safely.

## Boundaries

ADLC does not become a Hermes runner. ADLC creates source artifacts and handoff contracts. Hermes owns its own Kanban once cards are imported. Codex steps continue to use `adlc-implement`, `adlc-verify`, `adlc-review`, and `adlc-commit`.

## Consequences

Large epics can be planned up front, split into independent file-backed steps, and resumed across sessions without relying on chat memory or manual orchestration.
