# Sprint Package

An ADLC sprint package is the handoff boundary between planning and execution.

It should be readable by a human, a tracker importer, or a Kanban orchestrator. It should not depend on a hidden chat transcript.

## Package Layout

Default durable location:

```text
docs/adlc/sprints/<slug>/
  README.md
  adlc-sprint.yaml
  work-items/
    01-<item-slug>.md
    02-<item-slug>.md
  handoff.md
```

Use `.scratch/adlc-sprints/<slug>/` only for disposable experiments.

## README Contract

The sprint README should include:

- sprint name and goal
- source PRDs, specs, issue folders, or briefs
- owning repos and paths
- intended runner: human, tracker, Hermes, or undecided
- item list with AFK/HITL status
- dependency graph
- verification summary
- release and rollback posture
- blocked decisions
- exact next command or handoff action

## Manifest Contract

Use `adlc-sprint.yaml` as the machine-readable manifest. Keep it simple enough for scripts and agents to parse. During migration, runners may also read legacy `sprint-runner.yaml` manifests.

```yaml
name: "Sprint name"
materials_root: "."
state_file: "handoff.md"
default_isolation: "in-place-sequential"
publication: "local-commits" # local-commits | github-prs | stacked-prs | linked-cross-repo-prs | tracker-only
runner:
  preferred: "hermes-kanban" # optional
  board: "adlc-sprints"
  profiles:
    orchestrator: "sprintrunner"
    builder: "sprintbuilder"
    reviewer: "sprintreviewer"
    fixer: "sprintfixer"
  skills:
    orchestrator: ["kanban-orchestrator", "adlc-hermes"]
    build: ["kanban-worker", "adlc-build"]
    review: ["kanban-worker", "adlc-audit"]
    fix: ["kanban-worker", "adlc-close"]
    prove: ["kanban-worker", "adlc-prove"]
    release: ["kanban-worker", "adlc-release"]
    handoff: ["kanban-worker", "adlc-handoff"]
repos:
  web:
    path: "/absolute/path/to/repo"
    verify:
      - "pnpm typecheck"
      - "pnpm test"
items:
  - id: "01"
    title: "Short reviewable unit"
    spec: "work-items/01-short-reviewable-unit.md"
    repos: ["web"]
    depends_on: []
    status: "AFK"
    isolation_mode: "worktree"
    acceptance:
      - "Observable outcome"
    verify:
      web:
        - "pnpm typecheck"
```

Omit `runner` if the user has not chosen a runner. Do not encode secrets, tokens, production credentials, or irreversible commands.

## Work Item Contract

Each work item should include:

- id and title
- source PRD or slice
- purpose and user/operator outcome
- current behavior
- desired behavior
- repos and intended write scope
- out-of-scope surfaces
- dependencies
- AFK/HITL status and unresolved decisions
- acceptance criteria
- verification commands and evidence expectations
- release, rollback, and migration notes
- commit and publication expectation
- downstream review expectations

The item should be complete enough that a builder can start without reading every other sprint document.

## Readiness Gates

A sprint is ready for execution when:

- every item has acceptance criteria and verification
- every touched repo has a path and dirty-state expectation
- dependencies are explicit
- item order is deterministic where it must be
- independent items are safe to run independently
- release and rollback posture is classified
- HITL items either have a known blocker or are excluded from AFK execution
- commit/publication policy is explicit

## Runner Handoff

The runner handoff should answer:

- What should run the sprint?
- Where are the materials?
- Which items can start immediately?
- Which items are blocked?
- What profile or role should own build, review, fix, and publish work?
- Which ADLC skills should each runner phase load?
- What commands should the operator run to start and watch progress?

For Hermes, use `adlc-hermes` after the sprint package is ready.
