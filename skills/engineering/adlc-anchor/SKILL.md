---
name: adlc-anchor
description: Probe a plan against repo language, ADRs, and code, updating CONTEXT.md and docs/adr/ as decisions crystallize. Use when aligning on a feature, architecture, domain model, or plan that should be grounded in project documentation.
---

# ADLC Anchor

Anchor a plan in the repo's language and durable decisions.

This is `adlc-probe` plus documentation discipline. Ask one question at a time, but update docs when a term or decision becomes clear enough to preserve.

## Explore First

Before asking, inspect:

- `CONTEXT.md`
- `CONTEXT-MAP.md`, if present
- `docs/adr/`, if present
- relevant code, tests, and public interfaces
- nearby plans, PRDs, or issue drafts

If there is no `CONTEXT.md`, create it lazily only after the first project-specific term is resolved. If there is no `docs/adr/`, create it lazily only after the first ADR-worthy decision is made.

## During The Session

- Ask one question at a time.
- Provide options and your recommendation.
- Challenge fuzzy or overloaded terms.
- If the user uses a term that conflicts with `CONTEXT.md`, surface the conflict immediately.
- Stress-test relationships with concrete scenarios.
- Cross-check claims against code when possible.
- Update `CONTEXT.md` inline when terminology is resolved.
- Offer ADRs sparingly.

## CONTEXT.md

`CONTEXT.md` is a glossary and relationship map, not a spec or scratchpad.

Use [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md) when creating or updating it.

Add only project-specific language:

- domain terms
- product concepts
- workflow names
- system-specific roles
- relationships between those terms
- flagged ambiguities and their resolutions

Do not add generic programming concepts or implementation plans.

## ADRs

Use [ADR-FORMAT.md](./ADR-FORMAT.md).

Offer an ADR only when all three are true:

1. Hard to reverse.
2. Surprising without context.
3. The result of a real trade-off.

Skip ADRs for obvious, easy-to-change, or temporary choices.

## Closeout

End with:

- resolved terminology
- docs changed
- ADRs created or suggested
- remaining ambiguities
- recommended next action
