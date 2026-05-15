# Hermes ADLC Phases

Hermes should use ADLC skills as phase controls inside the Kanban graph.

Hermes owns durable execution state. ADLC skills define the quality gates for each phase.

## Required Skill Availability

Before seeding an ADLC sprint into Hermes, verify these local Hermes skills exist:

```text
adlc-sprint
adlc-hermes
adlc-build
adlc-audit
adlc-close
adlc-prove
adlc-release
adlc-handoff
```

Optional but common:

```text
adlc-diagnose
adlc-interface
adlc-polish
```

Install the public ADLC skills into Hermes with:

```bash
scripts/install-hermes-adlc-skills.sh
```

## Profile And Skill Map

Use real profile names discovered from `hermes profile list`. For the common local sprint setup:

| Kanban phase | Profile | Required skills |
| --- | --- | --- |
| Sprint orchestration | `sprintrunner` | `sprint-runner`, `kanban-orchestrator`, `adlc-hermes` |
| Package normalization | `sprintrunner` | `adlc-sprint`, `adlc-triage`, `kanban-orchestrator` |
| Build | `sprintbuilder` | `kanban-worker`, `adlc-build` |
| UI build | `sprintbuilder` | `kanban-worker`, `adlc-build`, `adlc-interface`, `adlc-polish` |
| Bug or failed check | `sprintbuilder` or `sprintfixer` | `kanban-worker`, `adlc-diagnose`, `adlc-build` |
| Hostile review | `sprintreviewer` | `kanban-worker`, `adlc-audit` |
| Review fixes | `sprintfixer` | `kanban-worker`, `adlc-close` |
| Verification proof | `sprintfixer` or `sprintreviewer` | `kanban-worker`, `adlc-prove` |
| Release readiness | `sprintfixer` or `sprintrunner` | `kanban-worker`, `adlc-release` |
| Continuity | `sprintrunner` or `sprintfixer` | `kanban-worker`, `adlc-handoff` |

Do not assign a task to a profile that does not exist. Do not include a skill that Hermes cannot list.

## Canonical Task Graph

For each AFK sprint item:

```text
item N build
  skills: kanban-worker, adlc-build
  assignee: sprintbuilder

item N hostile review
  parent: item N build
  skills: kanban-worker, adlc-audit
  assignee: sprintreviewer

item N review fixes
  parent: item N hostile review
  skills: kanban-worker, adlc-close
  assignee: sprintfixer
  only needed when review findings exist, or create as conditional follow-up

item N proof
  parent: item N review fixes or hostile review
  skills: kanban-worker, adlc-prove
  assignee: sprintfixer or sprintreviewer

item N release or handoff
  parent: item N proof
  skills: kanban-worker, adlc-release and/or adlc-handoff
  assignee: sprintrunner or sprintfixer
```

Dependent item N+1 starts after item N release/handoff when the dependency is real. Independent items can start in parallel.

## Worker Metadata

Every ADLC worker completion should include structured metadata. Keep it small and useful:

```json
{
  "adlc_phase": "build|audit|close|prove|release|handoff",
  "work_item": "01",
  "source_artifact": "work-items/01-example.md",
  "repos": ["web"],
  "changed_files": [],
  "verification": [],
  "findings": [],
  "commit_hashes": [],
  "residual_risk": [],
  "next_adlc_phase": "adlc-audit"
}
```

Block instead of complete when:

- the source artifact is not ready
- the profile cannot access the workspace
- a human decision is required
- verification cannot run for a missing credential, environment, or destructive approval
- a P0/P1/P2 review finding cannot be fixed safely inside scope

Use Kanban comments for context and `kanban_block` for the one-sentence decision needed.

## Phase Expectations

`adlc-build` workers should:

- inspect the source artifact and repo guidance
- make the smallest complete vertical-slice change
- run the strongest practical feedback loop
- complete with changed files, verification, residual risk, and next phase

`adlc-audit` workers should:

- review the actual diff against standards and spec
- report findings with severity, evidence, and fix direction
- complete with `approved: true` only when no blocking findings remain

`adlc-close` workers should:

- fix or explicitly classify every review finding
- rerun relevant verification
- complete with a finding ledger and unresolved risk

`adlc-prove` workers should:

- map each verification claim to evidence
- classify evidence as strong, partial, weak, blocked, or absent
- recommend the smallest next check for weak evidence

`adlc-release` workers should:

- identify rollout, rollback, migration, flag, and monitoring needs
- mark human-owned production steps explicitly
- avoid pretending merge equals release

`adlc-handoff` workers should:

- preserve branch, diff, commits, verification, blockers, and exact next step
- avoid duplicating large PRDs or diffs already captured elsewhere
