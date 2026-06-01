---
id: adlc-doc-plan-files
type: guide
status: active
owner: ADLC
---

# Plan Files

Plans are executable handoff artifacts. They should make implementation unambiguous enough that a coordinator can start work without rediscovering the whole project.

## Locations

- Fast plans: configured `paths.plan`, default `.adlc/PLAN.md`.
- Full plans: configured `paths.plans`, default `.adlc/plans/`.
- Fix plans: configured `paths.fixes`, default `.adlc/fixes/`.
- Workstreams: configured `paths.workstreams`, default `.adlc/workstreams/`.

## Required Content

Plans should include:

- goal
- current context and constraints
- task list with ownership
- dependencies
- acceptance criteria
- verification policy
- docs and QA needs
- commit checkpoints when useful
- open decisions

## Status

Use plain statuses such as `pending`, `active`, `blocked`, and `done`. Keep blocked decisions explicit instead of hiding them inside implementation tasks.

## Commit Checkpoints

When a plan has five or more tasks, include a commit plan. Commit checkpoints should map to meaningful reviewable slices, not arbitrary file batches.

## Workstreams

Use `adlc-workstream` instead of stretching one plan file when an epic needs milestones, many independent steps, Codex goal continuity, or staged handoff across sessions. Workstream steps still point back to ordinary ADLC plans when a step needs deeper implementation detail.
