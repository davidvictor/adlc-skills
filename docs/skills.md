---
id: adlc-doc-skills
type: guide
status: active
owner: ADLC
---

# Skills

ADLC ships 21 public skills.

## Setup And Discovery

- `adlc`: initialize or refresh project context.
- `adlc-explore`: investigate options before planning.
- `adlc-grounded`: answer from evidence when guessing is unsafe.

## Durable Context

- `adlc-architecture`: create or refresh architecture artifacts.
- `adlc-roadmap`: maintain milestones and sequencing.
- `adlc-rules`: capture project rules and area conventions.
- `adlc-reference`: create source-backed reference artifacts.

## Planning And Implementation

- `adlc-plan`: create executable plans.
- `adlc-workstream`: create grounded long-running workstreams with Codex goal-managed execution.
- `adlc-improve`: refine plans before execution.
- `adlc-implement`: execute plans with coordinator, workers, and sidecars.
- `adlc-fix`: diagnose and repair bugs.

## Gates And Closeout

- `adlc-verify`: prove completion against plan and repo behavior.
- `adlc-rules-check`: standalone rules gate.
- `adlc-security-checklist`: standalone security gate.
- `adlc-review`: code-review gate.
- `adlc-docs`: update lifecycle docs.
- `adlc-qa`: create QA artifacts.
- `adlc-commit`: stage and commit verified work.

## Continuous Improvement

- `adlc-loop`: run bounded iterative improvement.
- `adlc-evolve`: convert repeated lessons into durable rules or skill-context.

Every skill should resolve ADLC config paths before reading or writing lifecycle artifacts.
