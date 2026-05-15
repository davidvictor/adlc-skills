# ADLC Skills

Agent Development Lifecycle skills for real software work.

ADLC is a composable lifecycle for getting from fuzzy intent to shipped, verified work without surrendering engineering judgment.

The suite is intentionally portable:

- local repo artifacts are the durable default contract
- external trackers are optional adapters
- `CONTEXT.md` carries project language
- `docs/adr/` carries durable decisions
- `.scratch/adlc-*` carries local working artifacts
- verification is behavior-first and honest about gaps

## Install

```bash
npx skills@latest add davidvictor/adlc-skills
```

## Quickstart

1. Run `adlc-setup` in the target repo to record the local operating contract.
2. Use `adlc-plan` when the user needs an explicit planning path from intent to PRD, slices, or agent-ready work.
3. Use `adlc-probe` or `adlc-anchor` when decisions or repo language are unresolved.
4. Use `adlc-shape` and `adlc-slice` to turn resolved context into ready work.
5. Use `adlc-sprint` to package multiple PRDs or slices into a runner-ready sprint.
6. Use `adlc-hermes` when Hermes Kanban should execute or monitor that sprint.
7. Use `adlc-build` or `adlc-diagnose` for implementation.
8. Use `adlc-audit`, `adlc-close`, and `adlc-prove` before claiming done.
9. Use `adlc-release` when the change has production, data, integration, migration, scheduled-job, or user-facing risk.

New users can skim [the example lifecycle](./docs/examples/lifecycle-thread.md) and [golden outputs](./docs/examples/README.md) before using the suite.

## Planning Path

Use `adlc-plan` as the default entrypoint when a user asks to create a plan. It routes fuzzy intent through the existing primitives instead of replacing them:

1. `adlc-probe` for unresolved decisions.
2. `adlc-anchor` for repo language, ADR, or architecture alignment.
3. `adlc-shape` for the PRD or implementation contract.
4. `adlc-slice` for vertical implementation steps.
5. `adlc-triage` for AFK/HITL readiness and agent briefs.
6. `adlc-sprint` for a multi-PRD sprint package.
7. `adlc-hermes` for a Hermes Kanban handoff.

Example:

```text
$adlc-plan
Create a repo-grounded implementation plan for: <idea>. Write the PRD under docs/adlc/prds/<slug>.md, create local vertical issue drafts if ready, and prepare the result for a Hermes handoff. Do not implement.
```

## Lifecycle

1. [adlc-setup](./skills/engineering/adlc-setup/SKILL.md) - establish the repo operating contract.
2. [adlc-plan](./skills/engineering/adlc-plan/SKILL.md) - route intent through interview, shaping, slicing, and readiness.
3. [adlc-probe](./skills/engineering/adlc-probe/SKILL.md) or [adlc-anchor](./skills/engineering/adlc-anchor/SKILL.md) - resolve decisions and language.
4. [adlc-map](./skills/engineering/adlc-map/SKILL.md) or [adlc-deepen](./skills/engineering/adlc-deepen/SKILL.md) - understand or improve the codebase shape.
5. [adlc-shape](./skills/engineering/adlc-shape/SKILL.md) - write the execution-ready PRD.
6. [adlc-slice](./skills/engineering/adlc-slice/SKILL.md) and [adlc-triage](./skills/engineering/adlc-triage/SKILL.md) - create or classify ready work.
7. [adlc-sprint](./skills/engineering/adlc-sprint/SKILL.md) - package multiple PRDs or slices into a runner-ready sprint.
8. [adlc-hermes](./skills/engineering/adlc-hermes/SKILL.md) - hand a sprint package to Hermes Kanban.
9. [adlc-spike](./skills/engineering/adlc-spike/SKILL.md), [adlc-interface](./skills/engineering/adlc-interface/SKILL.md), or [adlc-polish](./skills/engineering/adlc-polish/SKILL.md) - explore and build product surfaces.
10. [adlc-build](./skills/engineering/adlc-build/SKILL.md) or [adlc-diagnose](./skills/engineering/adlc-diagnose/SKILL.md) - implement or fix with a strong feedback loop.
11. [adlc-audit](./skills/engineering/adlc-audit/SKILL.md), [adlc-close](./skills/engineering/adlc-close/SKILL.md), and [adlc-prove](./skills/engineering/adlc-prove/SKILL.md) - review, resolve, and prove.
12. [adlc-release](./skills/engineering/adlc-release/SKILL.md) - handle rollout, rollback, and operational evidence when risk warrants it.
13. [adlc-handoff](./skills/engineering/adlc-handoff/SKILL.md) - preserve continuity for future agents or sessions.

## Skills

### Setup And Intake

- [adlc-setup](./skills/engineering/adlc-setup/SKILL.md) - Establish a repo-local ADLC operating contract.
- [adlc-plan](./skills/engineering/adlc-plan/SKILL.md) - Create a plan from intent by routing through interview, shaping, slicing, and readiness.
- [adlc-triage](./skills/engineering/adlc-triage/SKILL.md) - Classify incoming work and prepare agent-ready briefs.
- [adlc-sprint](./skills/engineering/adlc-sprint/SKILL.md) - Assemble multiple PRDs, slices, or briefs into a runner-ready sprint package.
- [adlc-hermes](./skills/engineering/adlc-hermes/SKILL.md) - Prepare or seed a Hermes Kanban handoff from an ADLC sprint package.

### Alignment And Design

- [adlc-probe](./skills/engineering/adlc-probe/SKILL.md) - Interrogate a plan one decision at a time until the design tree is resolved.
- [adlc-anchor](./skills/engineering/adlc-anchor/SKILL.md) - Probe a plan against `CONTEXT.md`, ADRs, and code; update docs as decisions crystallize.
- [adlc-map](./skills/engineering/adlc-map/SKILL.md) - Zoom out and explain modules, callers, data flow, ownership, and verification surfaces.
- [adlc-deepen](./skills/engineering/adlc-deepen/SKILL.md) - Find architecture improvements that increase module depth, locality, and testability.
- [adlc-shape](./skills/engineering/adlc-shape/SKILL.md) - Turn resolved context into an execution-ready PRD.
- [adlc-slice](./skills/engineering/adlc-slice/SKILL.md) - Break a PRD or plan into vertical-slice work items.

### Product Surfaces And Implementation

- [adlc-spike](./skills/engineering/adlc-spike/SKILL.md) - Build a throwaway prototype that answers one design, state, logic, or UI question.
- [adlc-interface](./skills/engineering/adlc-interface/SKILL.md) - Design and implement domain-shaped frontend interfaces.
- [adlc-polish](./skills/engineering/adlc-polish/SKILL.md) - Refine frontend details through concrete tactile review.
- [adlc-build](./skills/engineering/adlc-build/SKILL.md) - Implement a vertical slice with a strong feedback loop.
- [adlc-diagnose](./skills/engineering/adlc-diagnose/SKILL.md) - Diagnose bugs and regressions before fixing them.

### Review, Release, And Continuity

- [adlc-audit](./skills/engineering/adlc-audit/SKILL.md) - Review a diff against both repo standards and the originating spec.
- [adlc-close](./skills/engineering/adlc-close/SKILL.md) - Convert review findings into fixes, deferrals, blockers, or accepted risks.
- [adlc-prove](./skills/engineering/adlc-prove/SKILL.md) - Audit verification claims and identify weak, skipped, or no-op checks.
- [adlc-release](./skills/engineering/adlc-release/SKILL.md) - Plan and verify rollout, rollback, and monitoring evidence.
- [adlc-handoff](./skills/engineering/adlc-handoff/SKILL.md) - Create durable handoffs for another agent or future session.
- [adlc-skill-maintain](./skills/engineering/adlc-skill-maintain/SKILL.md) - Maintain ADLC-style skill collections.

## Design Principles

- Ask in planning skills when decisions are unresolved; execute in implementation skills unless genuinely blocked.
- Preserve project language in `CONTEXT.md`.
- Record hard-to-reverse, surprising, trade-off decisions in ADRs.
- Keep local artifacts usable even when external trackers are configured.
- Build with strong feedback loops, not implied confidence.
- Verify through behavior and observable evidence.
- Say "not verified" when evidence is partial or absent.

## Validation

```bash
scripts/list-skills.sh
scripts/validate-skills.sh
scripts/smoke-skills.sh
```

## Hermes

Install ADLC skills into local Hermes when Hermes should run ADLC-packaged sprints:

```bash
scripts/install-hermes-adlc-skills.sh
```

Create the common sprint profiles and default ADLC board when needed:

```bash
scripts/setup-hermes-adlc-profiles.sh
```

Then use `adlc-sprint` to package PRDs and `adlc-hermes` to hand the package to Hermes Kanban. New packages use `adlc-sprint.yaml`; older `sprint-runner.yaml` manifests remain readable during migration.

To seed a package directly:

```bash
scripts/seed-adlc-hermes-sprint.sh --target-folder /absolute/path/to/docs/adlc/sprints/<slug>
```

For release readiness, see [docs/public-release-checklist.md](./docs/public-release-checklist.md).

## Packaging

This repo includes:

- `.claude-plugin/plugin.json` for Claude-compatible skill collection installs
- `agents/openai.yaml` inside every public skill for OpenAI/Codex-style metadata
- structural validation for indexes, manifests, links, metadata, scripts, and examples
