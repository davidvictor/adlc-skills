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
ready -> build -> review -> fix -> test -> commit -> done
```

`blocked` can replace any stage when the executor needs a human decision, credential, missing dependency, or safer plan.

Review, fix, and test gates are autonomous by default. A failed review or verify gate with actionable code, docs, tests, rules, or security findings should route to the suggested fixer or next gate, then return to review/verify without operator approval. Do not treat an ordinary post-fix `review-required` handoff as a human blocker.

Pause for a human only when the blocker is an explicit decision, credential or external account, destructive or production operation, legal/security sign-off, scope or product ambiguity, or user-requested approval point. On Kanban targets with coarse states, create a linked review/fix card for the autonomous gate instead of marking the work human-blocked.

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

When a human asks Codex to use Hermes, Codex manages the board setup and handoff.
Each Hermes card maps to one ADLC workstream step and carries the same lifecycle
gates: build, review, fix, test, and commit. Hermes workers should use a Codex
GPT-5.5 profile with xhigh reasoning unless a target project overrides that
profile. Worktree execution is configurable; ask before using a worktree unless
the project config or user request already requires it.

Codex should keep Hermes moving through autonomous review/fix/test loops. Human
review is a blocker only when the card identifies a human-gated reason such as a
decision, credential, production/destructive action, sign-off, or scope change.

Codex must not stop global Hermes services while managing a workstream. It may
stop only the Hermes task, session, or process it launched for the current work.
Stopping a gateway, daemon, scheduler, or other global service requires an
explicit operator request.

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
