---
id: adlc-doc-workstreams
type: guide
status: active
owner: ADLC
---

# Workstreams

Workstreams are ADLC's durable epic-planning layer. Use them when a scope is too large for one plan file or one execution turn, especially when Codex goals need file-backed continuity across multiple sessions.

## Purpose

A workstream turns an epic into grounded milestones and independent step cards. Each card has enough context to be executed later without replaying chat history.

The lifecycle is:

```text
ready -> build -> review -> fix -> test -> commit -> done
```

`blocked` can replace any stage when the active lane needs a human decision, credential, missing dependency, or safer plan.

Review, fix, and test gates are autonomous by default. A failed review or verify gate with actionable code, docs, tests, rules, or security findings should route to the suggested fixer or next gate, then return to review/verify without operator approval. Do not treat an ordinary post-fix `review-required` handoff as a human blocker.

Pause for a human only when the blocker is an explicit decision, credential or external account, destructive or production operation, legal/security sign-off, scope or product ambiguity, or user-requested approval point. On Kanban targets with coarse states, create a linked review/fix card for the autonomous gate instead of marking the work human-blocked.

## Location

Workstreams live under configured `paths.workstreams`, default `.adlc/workstreams/`.

```text
.adlc/workstreams/<slug>/
  WORKSTREAM.md
  kanban.md
  evidence.md
  decisions.md
  milestones/
  steps/
  handoff/
    codex-goal.md
```

## Grounding

Every step must cite evidence. Acceptable evidence includes repo files, ADLC docs, architecture/rules, runtime output, existing plans, issues, or explicit user decisions.

Do not create a step from intuition alone. If the evidence is missing, create a blocked discovery step or run `adlc-grounded` first.

## Execution Lanes

- `coordinator`: keep tightly coupled edits in the current Codex thread.
- `worker`: delegate one bounded task to a Codex worker.
- `parallel`: delegate independent tasks with disjoint write scopes.
- `human-gated`: pause for an explicit human decision, credential, external account, destructive or production operation, legal/security sign-off, scope ambiguity, or user-requested approval point.

## Goal Management

Codex goals carry the long-running objective. ADLC artifacts carry the detailed state:

- `WORKSTREAM.md`: objective, scope, goal status, and completion criteria.
- `milestones/*.md`: sprint-scale outcomes and exit criteria.
- `steps/*.md`: reviewable, commit-capable slices.
- `kanban.md`: stage state.
- `evidence.md`: source files, runtime output, and verification evidence.
- `decisions.md`: material decisions and human-gated blockers.

## CLI

Create a scaffold:

```bash
adlc workstream create project-automation /path/to/project --title "Project Automation" --lane coordinator
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

## Milestone Requirements

Each milestone card must include:

- outcome
- evidence
- dependencies
- step scope
- exit criteria
- verification strategy
- release or rollback notes
- blockers

## Step Requirements

Each step card must include:

- goal
- evidence
- bounded write scope
- task breakdown
- dependencies
- build instructions
- review gate
- fix gate
- test gate
- commit checkpoint
- done criteria
- transition rule

## Relationship To Plans

`adlc-workstream` plans the epic and creates milestone and step cards. `adlc-plan` can still create detailed implementation plans for one step when needed. `adlc-implement`, `adlc-verify`, `adlc-review`, and `adlc-commit` execute the selected step lifecycle.

Workstreams should not become a second hidden project tracker. They exist to make long-running work explicit, file-backed, and handoff-safe.
