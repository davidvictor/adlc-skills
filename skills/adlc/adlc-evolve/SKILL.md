---
name: adlc-evolve
description: Distill repeated patches and review findings into ADLC rules or skill updates.
---

# ADLC Evolve

Use this when fixes, reviews, or failed runs reveal reusable operating knowledge.

## Process

1. Read new `.adlc/patches/` entries and recent gate failures.
2. Identify repeated patterns, missing rules, weak skill instructions, or stale project context.
3. Update `.adlc/skill-context/` or `.adlc/RULES.md` for project-local learning.
4. Update this ADLC repo only when the lesson is cross-project and stable.
5. Keep changes narrow and validate after ADLC source edits.

## Output

Report consumed patches, rules or skills updated, deferred lessons, and validation result.
