# ADLC Workstream Contract

Workstreams are durable epic execution plans. They sit above ordinary ADLC plans and create staged, executor-ready step cards.

## Directory Shape

```text
.adlc/workstreams/<slug>/
  WORKSTREAM.md
  kanban.md
  evidence.md
  steps/
    0001-<slug>.md
  handoff/
    codex.md
    hermes.md
```

## Required Stages

Every step moves through this lifecycle:

```text
ready -> build -> review -> test -> commit -> done
```

`blocked` can replace any active stage when a human decision, missing credential, failing dependency, or unsafe operation prevents progress.

## Step Contract

Each step card must include:

- stable `id`
- `stage`
- `executor`
- evidence sources
- bounded write scope
- dependencies
- build instructions
- review gate
- test gate
- commit checkpoint
- done criteria
- next-stage transition rule

## Executor Lanes

- `codex`: executable through `adlc-implement`, Codex workers, and read-only sidecars.
- `hermes`: exported as a Hermes Kanban card; Hermes owns active board movement after handoff.
- `either`: safe for Codex or Hermes, with the same lifecycle contract.

## Long-Running Management

The workstream root is the source of truth. Chat summaries are not state. Executors must update step cards and Kanban state as work moves across lifecycle stages.

## Grounding Rule

No step should exist without at least one evidence source: a repo file, doc artifact, runtime output, issue, user requirement, or explicit decision.
