# Workflow-Complete Lifecycle Surface

Status: Accepted

## Context

The original ADLC repo had a strong planning and verification spine, but it skipped several SDLC phases: repo setup, intake triage, implementation, diagnosis, frontend craft, release, handoff, and skill-suite maintenance.

The upgrade goal is operational usability across the whole lifecycle, not full public-release polish with exhaustive examples.

## Decision

ADLC exposes a workflow-complete but lean skill surface:

- setup and operating contract
- probe and anchor
- map and deepen
- shape and slice
- triage
- spike, interface, and polish
- build and diagnose
- audit, close, and prove
- release and handoff
- skill maintenance

This pass prioritizes usable contracts and complete flow. Larger golden examples and full cross-agent metadata can deepen later.

## Consequences

The repo should feel complete to an operator moving from fuzzy intent to verified release. Individual skills should stay concise and avoid pretending every phase is equally deep on day one.
