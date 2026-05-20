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
7. Hand the fix back to an autonomous review or verify gate when scoped checks pass. Do not label ordinary code, docs, tests, rules, or security fixes as needing human review.

## Human-Gated Blockers

Pause for the operator only when the next step requires an explicit human decision, credential or external account, destructive or production operation, legal/security sign-off, scope or product ambiguity, or user-requested approval point.

## Output

Report root cause, changed files, verification, patch note path, whether `adlc-evolve` should run, and the next gate: autonomous `adlc-review`/`adlc-verify` or a specific human-gated blocker reason.
