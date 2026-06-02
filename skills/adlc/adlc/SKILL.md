---
name: adlc
description: Initialize or refresh ADLC project context and config artifacts.
---

# ADLC Setup

Use this when a repo needs ADLC context before planning or implementation.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml` when present; use `adlc resolve-config` when the CLI is available.
2. Read repo guidance, current docs, package/tooling files, and git state.
3. Create or refresh `.adlc/config.yaml` from this repo's template.
4. Create or refresh:
   - `.adlc/DESCRIPTION.md`
   - `.adlc/ARCHITECTURE.md`
   - `.adlc/RULES.md`
5. Keep project-specific rules in `.adlc/RULES.md`; keep broad agent behavior in `AGENTS.md`.
6. Do not create plans or implement features from setup.

## Output

Report created/updated files, missing context, and the recommended next command: `adlc-explore`, `adlc-grounded`, `adlc-interview`, or `adlc-plan`.
