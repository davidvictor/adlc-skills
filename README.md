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

## Lifecycle

1. [adlc-setup](./skills/engineering/adlc-setup/SKILL.md) - establish the repo operating contract.
2. [adlc-probe](./skills/engineering/adlc-probe/SKILL.md) or [adlc-anchor](./skills/engineering/adlc-anchor/SKILL.md) - resolve decisions and language.
3. [adlc-map](./skills/engineering/adlc-map/SKILL.md) or [adlc-deepen](./skills/engineering/adlc-deepen/SKILL.md) - understand or improve the codebase shape.
4. [adlc-shape](./skills/engineering/adlc-shape/SKILL.md) - write the execution-ready PRD.
5. [adlc-slice](./skills/engineering/adlc-slice/SKILL.md) and [adlc-triage](./skills/engineering/adlc-triage/SKILL.md) - create or classify ready work.
6. [adlc-spike](./skills/engineering/adlc-spike/SKILL.md), [adlc-interface](./skills/engineering/adlc-interface/SKILL.md), or [adlc-polish](./skills/engineering/adlc-polish/SKILL.md) - explore and build product surfaces.
7. [adlc-build](./skills/engineering/adlc-build/SKILL.md) or [adlc-diagnose](./skills/engineering/adlc-diagnose/SKILL.md) - implement or fix with a strong feedback loop.
8. [adlc-audit](./skills/engineering/adlc-audit/SKILL.md), [adlc-close](./skills/engineering/adlc-close/SKILL.md), and [adlc-prove](./skills/engineering/adlc-prove/SKILL.md) - review, resolve, and prove.
9. [adlc-release](./skills/engineering/adlc-release/SKILL.md) - handle rollout, rollback, and operational evidence when risk warrants it.
10. [adlc-handoff](./skills/engineering/adlc-handoff/SKILL.md) - preserve continuity for future agents or sessions.

## Skills

### Setup And Intake

- [adlc-setup](./skills/engineering/adlc-setup/SKILL.md) - Establish a repo-local ADLC operating contract.
- [adlc-triage](./skills/engineering/adlc-triage/SKILL.md) - Classify incoming work and prepare agent-ready briefs.

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
```
