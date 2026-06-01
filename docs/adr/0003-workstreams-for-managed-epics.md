---
id: adlc-adr-0003-workstreams
type: adr
status: accepted
owner: ADLC
---

# ADR 0003: Workstreams Manage Long-Running Epics

Status: accepted

## Context

Some scopes are too large for a single ADLC plan or one Codex session. Large work needs goal continuity, grounded step boundaries, milestone state, and lifecycle gates that survive resumes.

## Decision

ADLC adds `adlc-workstream` and `adlc workstream` as the durable epic-planning surface.

Workstreams live under `paths.workstreams`, default `.adlc/workstreams/`. A workstream contains an overview, evidence, decisions, Kanban state, milestone cards, step cards, and a Codex goal handoff.

Every step moves through:

```text
ready -> build -> review -> fix -> test -> commit -> done
```

`blocked` is available whenever the lane cannot proceed safely.

## Boundaries

Codex goals own the long-running objective. ADLC artifacts own detailed scope, evidence, decisions, gates, and commit checkpoints. Codex steps continue to use `adlc-implement`, `adlc-verify`, `adlc-review`, and `adlc-commit`.

## Consequences

Large epics can be planned up front, split into independent file-backed steps, and resumed across sessions without relying on chat memory or manual orchestration.
