---
name: adlc-skill-maintain
description: Maintain ADLC-style skill collections. Use when adding, updating, validating, packaging, or reviewing skills, manifests, references, examples, or repo guidance.
---

# ADLC Skill Maintain

Keep skill repos coherent and installable.

## Process

1. Read repo guidance, especially `AGENTS.md`.
2. Identify the skill surface being added or changed.
3. Keep `SKILL.md` concise and move detail into one-level references.
4. Update all indexes and manifests.
5. Add ADRs for durable lifecycle or packaging decisions.
6. Run validation before closeout.

Use [MAINTENANCE-CHECKLIST.md](./MAINTENANCE-CHECKLIST.md).

## Rules

- Do not add a public skill without the `adlc-` prefix.
- Do not copy another repo's voice or prose.
- Do not let README, engineering index, and plugin manifest drift.
- Do not add large examples unless they improve agent behavior.
- Prefer operational instructions over explanatory essays.

## Closeout

Report:

- skills added or changed
- manifests and indexes updated
- validation command and result
- examples or metadata intentionally deferred
