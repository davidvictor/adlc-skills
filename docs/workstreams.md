---
id: adlc-doc-workstreams
type: guide
status: active
owner: ADLC
---

# Workstreams

Workstreams are ADLC's durable epic-planning layer. Use them when a scope is too large for one plan file or one execution turn, especially when work may be handed to Codex or Hermes over multiple sessions.

## Purpose

A workstream turns an epic into grounded, independent step cards. Each card has enough context to be executed later without replaying chat history.

The lifecycle is:

```text
ready -> build -> review -> test -> commit -> done
```

`blocked` can replace any stage when the executor needs a human decision, credential, missing dependency, or safer plan.

## Location

Workstreams live under configured `paths.workstreams`, default `.adlc/workstreams/`.

```text
.adlc/workstreams/<slug>/
  WORKSTREAM.md
  evidence.md
  kanban.md
  steps/
  handoff/
    codex.md
    hermes.md
```

Hermes sync also writes:

```text
.hermes/
  config.yaml
  kanban.json
  inbox/
  workstreams/
```

## Grounding

Every step must cite evidence. Acceptable evidence includes repo files, ADLC docs, architecture/rules, runtime output, existing plans, issues, or explicit user decisions.

Do not create a step from intuition alone. If the evidence is missing, create a blocked discovery step or run `adlc-grounded` first.

## Executor Lanes

- `codex`: use `adlc-implement` and Codex workers/sidecars.
- `hermes`: export as a Hermes Kanban card; Hermes owns active board movement after handoff.
- `either`: safe for Codex or Hermes.

ADLC does not run Hermes. ADLC owns the source workstream and the handoff contract. Hermes owns its own Kanban once work is imported.

## CLI

Create a scaffold:

```bash
adlc workstream create project-automation /path/to/project --title "Project Automation" --executor either
```

Inspect stage state:

```bash
adlc workstream status project-automation /path/to/project
adlc workstream status project-automation /path/to/project --json
```

Advance a step:

```bash
adlc workstream advance project-automation 0001 /path/to/project --stage build
```

Sync to Hermes:

```bash
adlc workstream sync project-automation /path/to/project --agent hermes
```

## Step Requirements

Each step card must include:

- goal
- evidence
- bounded write scope
- dependencies
- build instructions
- review gate
- test gate
- commit checkpoint
- done criteria
- transition rule

## Relationship To Plans

`adlc-workstream` plans the epic and creates step cards. `adlc-plan` can still create detailed implementation plans for one step when needed. `adlc-implement`, `adlc-verify`, `adlc-review`, and `adlc-commit` execute the selected step lifecycle.

Workstreams should not become a second hidden project tracker. They exist to make long-running work explicit, file-backed, and handoff-safe.
