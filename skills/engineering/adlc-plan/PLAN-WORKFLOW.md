# Plan Workflow

`adlc-plan` is an orchestrator. It makes the planning path obvious without replacing the deeper skills.

## Start Here

Use `adlc-plan` when the user asks to create:

- a plan
- an implementation plan
- a roadmap
- a PRD
- a spec
- issue drafts
- agent-ready work from an idea

If the user directly names a more specific skill, use that skill instead.

## Intake

Capture these fields as facts, assumptions, open questions, or deferred decisions:

- **Outcome**: what changes for the user, operator, or system?
- **Current state**: what already exists?
- **Target behavior**: what should be true after the work?
- **Users and operators**: who experiences, invokes, maintains, or approves the change?
- **Scope**: what is in this pass?
- **Non-goals**: what is explicitly out?
- **Constraints**: technical, product, data, auth, cost, timeline, compliance, or operational limits.
- **Interfaces**: UI surfaces, APIs, commands, modules, data contracts, events, jobs, or external systems.
- **Edge cases**: unsupported inputs, empty states, errors, blocked states, migration states, and rollback states.
- **Verification**: tests, browser checks, scripts, logs, migrations, screenshots, or operator evidence.
- **Release and rollback**: flags, migrations, staged rollout, observability, fallback, and backout path.
- **Dependencies**: people, credentials, services, data, designs, third-party systems, and prior slices.
- **Acceptance conditions**: exact evidence needed before the plan can be called ready.

Do not make unverified assumptions sound settled. Keep them visible.

## Routing

Use this route map:

| Situation | Route |
| --- | --- |
| The idea is fuzzy or options are unresolved | `adlc-probe` |
| The plan must fit repo language, ADRs, or current architecture | `adlc-anchor` |
| The codebase shape is unknown | `adlc-map` |
| The architecture needs improvement before implementation | `adlc-deepen` |
| One design, logic, or UI question needs evidence | `adlc-spike` |
| The decisions are resolved and need a durable artifact | `adlc-shape` |
| The PRD/spec needs implementation steps | `adlc-slice` |
| Work items need readiness classification or agent briefs | `adlc-triage` |
| Multiple PRDs or slices need one execution package | `adlc-sprint` |
| A sprint should be handed to Hermes Kanban | `adlc-hermes` |
| A ready slice should be implemented | `adlc-build` |

## Artifact Ladder

Move down this ladder only when the previous level is strong enough:

1. **Decision log**: resolved decisions, assumptions, open questions, deferred decisions, risks.
2. **PRD or implementation contract**: user-visible behavior, contracts, scope, acceptance criteria, verification, release posture.
3. **Vertical slices**: independently useful issue drafts with AFK/HITL status and dependencies.
4. **Agent briefs**: ready-for-agent execution context for AFK work.
5. **Sprint package**: multi-PRD execution package with manifest, work items, dependency graph, verification, and publication policy.
6. **Runner handoff**: Hermes, tracker, or human-runner handoff with commands and blocked decisions.
7. **Implementation**: handled by `adlc-build` or a runner such as Hermes, not by `adlc-plan`.

## Default Locations

Use repo-local Markdown by default:

```text
docs/adlc/prds/<slug>.md
.scratch/adlc-issues/<slug>/
.scratch/adlc-agent-briefs/<slug>/
docs/adlc/sprints/<slug>/
```

Use other locations only when the user asks or the operating contract specifies them.

## Commands A User Can Run Today

For a fuzzy idea:

```text
$adlc-plan
Create a plan for: <idea>. Interview me one decision at a time before shaping. Do not implement.
```

For a repo-grounded plan:

```text
$adlc-plan
Create a repo-grounded implementation plan for: <idea>. Use CONTEXT.md, ADRs, and the current codebase. Write the PRD under docs/adlc/prds/<slug>.md and do not implement.
```

For a resolved idea that needs steps:

```text
$adlc-plan
Turn this resolved scope into a PRD and vertical issue drafts: <scope>. Use local Markdown artifacts and mark AFK/HITL slices.
```

For execution handoff:

```text
$adlc-plan
Convert this PRD into ready-for-agent work. Create vertical issue drafts and agent briefs for AFK slices.
```

For a Hermes-bound sprint:

```text
$adlc-plan
Turn these PRDs into a sprint package that can be handed to Hermes Kanban. Include dependencies, AFK/HITL status, verification, and publication policy. Do not implement.
```

## Readiness Test

A plan is ready for slicing when:

- the target behavior is specific
- non-goals are explicit
- implementation boundaries are known enough to avoid broad guessing
- acceptance criteria are testable
- verification evidence is named
- release and rollback risk is classified
- unresolved decisions are either closed, deferred, or called out as blockers

A plan is ready for `adlc-build` only after the selected slice is AFK or the required HITL decision has been resolved.
