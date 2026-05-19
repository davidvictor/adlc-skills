---
name: adlc-evolve
description: Distill repeated patches and review findings into ADLC rules or skill updates.
---

# ADLC Evolve

Use this when fixes, reviews, or failed runs reveal reusable operating knowledge.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read new configured patch entries and recent gate failures.
3. Identify repeated patterns, missing rules, weak skill instructions, or stale project context.
4. Update configured skill-context or rules files for project-local learning.
5. Update this ADLC repo only when the lesson is cross-project and stable.
6. Keep changes narrow and validate after ADLC source edits.

## Output

Report consumed patches, rules or skills updated, deferred lessons, and validation result.
