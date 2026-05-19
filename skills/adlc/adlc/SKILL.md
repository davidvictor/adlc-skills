---
name: adlc
description: Initialize or refresh ADLC project context and config artifacts.
---

# ADLC Setup

Use this when a repo needs ADLC context before planning or implementation.

## Process

1. Read repo guidance, current docs, package/tooling files, and git state.
2. Create or refresh `.adlc/config.yaml` from this repo's template.
3. Create or refresh:
   - `.adlc/DESCRIPTION.md`
   - `.adlc/ARCHITECTURE.md`
   - `.adlc/RULES.md`
4. Keep project-specific rules in `.adlc/RULES.md`; keep broad runtime behavior in `AGENTS.md`.
5. Do not create plans or implement features from setup.

## Output

Report created/updated files, missing context, and the recommended next command: `adlc-explore`, `adlc-grounded`, or `adlc-plan`.
