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

Install the public ADLC skills into Hermes from the ADLC skills checkout:

```bash
cd /Users/davidvictor/.codex/workspaces/default/repos/adlc-skills
scripts/install-hermes-adlc-skills.sh
```

## Profile And Skill Map

Use real profile names discovered from `hermes profile list`. For the common local sprint setup:

| Kanban phase | Profile | Required skills |
| --- | --- | --- |
| Sprint orchestration | `sprintrunner` | `kanban-orchestrator`, `adlc-hermes` |
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
  completion: implemented and self-verified; review_required=true

item N hostile review
  parent: item N build
  skills: kanban-worker, adlc-audit
  assignee: sprintreviewer
  completion: approved true or false with finding ledger

item N review fixes
  parent: item N hostile review
  skills: kanban-worker, adlc-close
  assignee: sprintfixer
  only needed when review findings exist, or create as conditional follow-up
  completion: findings fixed/deferred/blocked with fresh verification

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

Use `adlc-sprint.yaml` as the canonical manifest when deriving graph dependencies. Legacy `sprint-runner.yaml` files may be read for older sprint packages, but new tasks should not load the retired `sprint-runner` skill.

## Transition Rules

Normal quality gates must move the graph forward:

- Build tasks complete after implementation and self-verification. They must not block just because hostile review is required.
- Audit tasks complete after review, even when `approved=false`, as long as the finding ledger is clear enough for a fix agent.
- Close tasks complete after every finding is fixed, deferred with an owner, accepted as residual risk, or blocked with exact evidence.
- Proof tasks complete when each verification claim has a verdict. A partial or weak verdict is still useful evidence when the next check is named.

Use blocked state only for true stop conditions:

- source artifact is not ready
- profile cannot access the workspace
- human planning or scope decision is required
- verification cannot run for a missing credential, environment, or destructive approval
- a P0/P1/P2 review finding cannot be fixed safely inside approved scope

Recommended blocked reason prefixes:

- `human-decision:` for planning, product, or scope calls
- `credential-blocker:` for missing auth, secret, account, or browser/session state
- `environment-blocker:` for missing local tooling or unavailable services
- `scope-expansion:` for findings that need new approved work
- `unsafe-verification:` for destructive or production-risk checks

Do not use `review-required:` as a blocked reason. Review is the next phase, not a stop condition.

## Notification Contract

Hermes lifecycle notifications should make the ADLC graph visible without turning Telegram into a tracker.

- `claimed` means a phase started.
- `completed` means a phase reached its handoff and dependent work can promote.
- `blocked` and `gave_up` mean human attention is required; include the exact decision, credential, environment, scope, or verification blocker.
- `crashed` and `timed_out` mean the dispatcher will retry unless the pattern repeats.

Use plain profile labels such as `Worker: reviewer`. Do not format Hermes profiles as Telegram mentions like `@Sprint Runner`; those are not real Telegram users and create noisy, invalid notifications.

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
  "approved": null,
  "review_required": false,
  "findings_resolved": [],
  "commit_hashes": [],
  "residual_risk": [],
  "next_adlc_phase": "adlc-audit"
}
```

For audit findings, use stable ids so fix agents can act without re-reviewing:

```json
{
  "id": "A1",
  "axis": "Standards|Spec",
  "severity": "critical|high|medium|low",
  "blocking": true,
  "scope": "in-scope|scope-expansion|human-decision",
  "evidence": "<file, command, behavior, or missing contract>",
  "fix_direction": "<smallest safe fix or decision needed>",
  "verification_required": ["<command or observable check>"]
}
```

Use Kanban comments for context. Use `kanban_block` only for the one-sentence decision or missing condition needed to continue.

## Phase Expectations

`adlc-build` workers should:

- inspect the source artifact and repo guidance
- make the smallest complete vertical-slice change
- run the strongest practical feedback loop
- complete with changed files, verification, residual risk, `review_required=true`, and `next_adlc_phase=adlc-audit`

`adlc-audit` workers should:

- review the actual diff against standards and spec
- report findings with severity, evidence, and fix direction
- complete with `approved: true` only when no blocking findings remain
- complete with `approved: false` and a finding ledger when fixes are required

`adlc-close` workers should:

- post a short fix plan before editing
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
