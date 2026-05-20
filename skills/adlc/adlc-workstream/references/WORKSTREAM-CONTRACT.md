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
ready -> build -> review -> fix -> test -> commit -> done
```

`blocked` can replace any active stage when a human decision, missing credential, failing dependency, or unsafe operation prevents progress.

## Gate Routing

Review, fix, and test gates are autonomous by default. `blocked` is not a synonym for "needs the next ADLC gate." When a review or verify gate fails with actionable code, docs, tests, rules, or security findings, route to the suggested fixer or next gate and continue the loop:

```text
review/verify fail -> fix -> scoped checks -> review/verify -> test -> commit
```

Pause for a human only when the blocker is an explicit decision, credential or external account, destructive or production operation, legal/security sign-off, scope or product ambiguity, or user-requested approval point.

If a Kanban target has coarse states only, represent the next autonomous gate as a linked or child card instead of marking the current card human-blocked. A post-fix handoff that only says `review-required` should start the autonomous reviewer/verifier, not page the operator.

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
- fix gate when review or test fails
- test gate
- commit checkpoint
- done criteria
- next-stage transition rule

## Executor Lanes

- `codex`: executable through `adlc-implement`, Codex workers, and read-only sidecars.
- `hermes`: exported as a Hermes Kanban card; Hermes owns active board movement after handoff.
- `either`: safe for Codex or Hermes, with the same lifecycle contract.

For Hermes workstreams, Codex is the board operator. Codex prepares and syncs
the Kanban, then Hermes executes cards with their ADLC IDs and gates intact.
Hermes worker profiles should use Codex GPT-5.5 with xhigh reasoning unless the
target project overrides that profile.

## Long-Running Management

The workstream root is the source of truth. Chat summaries are not state. Executors must update step cards and Kanban state as work moves across lifecycle stages.

## Grounding Rule

No step should exist without at least one evidence source: a repo file, doc artifact, runtime output, issue, user requirement, or explicit decision.
