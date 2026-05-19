---
name: adlc-fix
description: Diagnose and fix bugs while writing reusable learning patches for future runs.
---

# ADLC Fix

Use this for failures, bugs, regressions, flaky checks, and hotfixes.

## Modes

- `fix now`: reproduce, diagnose, patch, verify.
- `plan first`: write `.adlc/fixes/<slug>.md` and stop for review.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Reproduce or observe the failure before editing.
3. Minimize the failing surface.
4. Patch the smallest behavior boundary.
5. Add or update regression evidence when practical.
6. Write a patch note under the configured patches path when the lesson should improve future work.

## Output

Report root cause, changed files, verification, patch note path, and whether `adlc-evolve` should run.
