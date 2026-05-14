# ADLC Skills

Agent Development Lifecycle skills for real software work.

ADLC stands for **Agent Development Lifecycle**: a small, composable workflow for getting from fuzzy intent to shipped, verified work without surrendering engineering judgment.

These skills are intentionally universal. They assume any repository can carry:

- `CONTEXT.md` for project-specific language
- `docs/adr/` for durable architectural decisions
- Markdown issue drafts by default, with external trackers used only when explicitly requested

## Skills

### Engineering

- [adlc-probe](./skills/engineering/adlc-probe/SKILL.md) — Interrogate a plan one decision at a time until the design tree is resolved.
- [adlc-anchor](./skills/engineering/adlc-anchor/SKILL.md) — Probe a plan against `CONTEXT.md`, ADRs, and code; update docs as decisions crystallize.
- [adlc-map](./skills/engineering/adlc-map/SKILL.md) — Zoom out and explain the relevant modules, callers, data flow, and ownership.
- [adlc-deepen](./skills/engineering/adlc-deepen/SKILL.md) — Find architecture improvements that increase module depth, locality, and testability.
- [adlc-shape](./skills/engineering/adlc-shape/SKILL.md) — Turn resolved context into an execution-ready PRD.
- [adlc-slice](./skills/engineering/adlc-slice/SKILL.md) — Break a PRD or plan into vertical-slice Markdown issue drafts.
- [adlc-spike](./skills/engineering/adlc-spike/SKILL.md) — Build a throwaway prototype that answers one design, state, logic, or UI question.
- [adlc-audit](./skills/engineering/adlc-audit/SKILL.md) — Review a diff against both repo standards and the originating spec.
- [adlc-close](./skills/engineering/adlc-close/SKILL.md) — Convert review findings into fixes, deferrals, or accepted risks with fresh evidence.
- [adlc-prove](./skills/engineering/adlc-prove/SKILL.md) — Audit verification claims and identify weak, skipped, or no-op checks.

## Suggested Flow

1. `adlc-probe` or `adlc-anchor` to align.
2. `adlc-map` or `adlc-deepen` when the codebase shape matters.
3. `adlc-spike` when a question needs a quick prototype.
4. `adlc-shape` to write the PRD.
5. `adlc-slice` to create issue drafts.
6. Implement with normal coding/test discipline.
7. `adlc-audit`, `adlc-close`, and `adlc-prove` before claiming done.

## Install

This repo is structured as a skill collection. If your agent supports GitHub skill repos, install the whole collection or copy the individual skill folders you want.

```bash
npx skills@latest add davidvictor/adlc-skills
```

## Design Principles

- Skills accomplish SDLC tasks; they do not recursively generate other skills.
- Ask only when the answer is not discoverable from the repo or docs.
- Prefer one high-leverage question over a questionnaire dump.
- Preserve project language in `CONTEXT.md`.
- Record hard-to-reverse, surprising, trade-off decisions in ADRs.
- Keep issue drafts tracker-neutral unless the user explicitly asks to publish.
- Verify through behavior, not implementation details.
- Say "not verified" when evidence is partial or absent.
