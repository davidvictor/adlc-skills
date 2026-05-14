# Explicit Planning Entrypoint

Status: Accepted

## Context

ADLC already had the primitives needed to plan work: `adlc-probe` for unresolved decisions, `adlc-anchor` for repo grounding, `adlc-shape` for PRDs, `adlc-slice` for vertical work, and `adlc-triage` for readiness.

The gap was discoverability. A user asking "how do I create a plan?" had to infer that planning starts with probe or anchor and then moves through shape and slice. That made the lifecycle feel thinner than it was.

## Decision

ADLC exposes `adlc-plan` as the explicit planning entrypoint.

`adlc-plan` is an orchestrator, not a replacement planning framework. It routes intent through the existing skills and makes the artifact ladder clear:

- decision log
- PRD or implementation contract
- vertical issue drafts
- agent briefs
- implementation by `adlc-build`

## Consequences

Users can now start with one obvious skill when they need a plan. The deeper planning skills remain responsible for their specific work, and ADLC avoids duplicating interview, shaping, slicing, or triage logic in a second place.
