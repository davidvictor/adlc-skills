# ADLC Workstream Contract

Workstreams are durable epic execution plans. They sit above ordinary ADLC plans and create Codex goal-managed milestones, step cards, and gate state for large software efforts.

## Directory Shape

```text
.adlc/workstreams/<slug>/
  WORKSTREAM.md
  kanban.md
  evidence.md
  decisions.md
  milestones/
    0001-<slug>.md
  steps/
    0001-<slug>.md
  handoff/
    codex-goal.md
```

## Required Hierarchy

Use this hierarchy for large work:

```text
workstream -> milestone -> step -> task -> gate -> commit
```

- Workstream: the whole multi-sprint objective and Codex goal context.
- Milestone: a coherent sprint-scale outcome with exit criteria.
- Step: a reviewable, commit-capable implementation slice.
- Task: a concrete action inside one step.
- Gate: verify, review, rules, security, docs, QA, or commit readiness.
- Commit: the smallest coherent landed unit for the completed slice.

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
- `milestone`
- execution `lane`
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

## Execution Lanes

- `coordinator`: tightly coupled edits that should stay in the current Codex thread.
- `worker`: one independent bounded task for a Codex subagent.
- `parallel`: multiple independent bounded tasks with disjoint write scopes.
- `human-gated`: blocked on an explicit human decision, credential, external account, destructive or production operation, legal/security sign-off, scope ambiguity, or user-requested approval point.

## Goal Management

The active Codex goal represents the long-running workstream objective. Use it for continuity across resumes and multi-sprint execution. Keep detailed state in ADLC artifacts:

- `WORKSTREAM.md`: objective, scope, active goal, milestone index, completion criteria.
- `kanban.md`: stage state for milestones and steps.
- `evidence.md`: source files, runtime output, docs, decisions, and verification links.
- `decisions.md`: material decisions and human-gated blockers.
- `milestones/*.md`: milestone outcomes, dependencies, exit criteria, and release notes.
- `steps/*.md`: step contracts, task lists, gates, and commit checkpoints.

On resume, read the workstream artifacts before relying on conversation history. Use Codex goal status for active objective tracking; update it only when the full objective is complete or the same blocking condition has reached the tool's blocked threshold.

## Long-Running Management

The workstream root is the source of truth. Chat summaries are not state. Agents must update step cards, milestone cards, and Kanban state as work moves across lifecycle stages.

## Grounding Rule

No step should exist without at least one evidence source: a repo file, doc artifact, runtime output, issue, user requirement, or explicit decision.
