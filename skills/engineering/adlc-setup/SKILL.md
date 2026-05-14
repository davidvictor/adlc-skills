---
name: adlc-setup
description: Establish a repo-local ADLC operating contract. Use when adopting ADLC in a repo, configuring issue trackers, domain docs, verification commands, handoff locations, or release expectations.
---

# ADLC Setup

Create the repo contract that all other ADLC skills can trust.

## Explore

Inspect before asking:

- repo guidance: `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`
- remotes and tracker clues: `.git/config`, issue URLs, docs, labels
- domain docs: `CONTEXT.md`, `CONTEXT-MAP.md`, `docs/adr/`
- work surfaces: `.scratch/`, `docs/`, existing plans/issues
- verification: package scripts, CI, test commands, browser/e2e setup
- release surfaces: deployment config, migrations, jobs, env examples

## Decisions

Walk only unresolved decisions, one at a time:

1. Work tracking: local Markdown, GitHub, Linear, Jira, or other adapter.
2. Domain docs: single context or multi-context map.
3. Verification: default commands and when browser/manual proof is required.
4. Release: whether the repo has production, data, integration, or operational risk.

Default to a hybrid contract: local artifacts first, optional tracker publishing.

## Write

Create or update:

- `docs/adlc/operating-contract.md` using [OPERATING-CONTRACT.md](./OPERATING-CONTRACT.md)
- the repo guidance file named by the user, normally `AGENTS.md` or existing equivalent
- tracker or label mapping docs under `docs/adlc/` when configured

Do not create external tracker labels or issues unless explicitly asked.

## Closeout

Report:

- contract path
- tracker policy
- domain doc layout
- verification commands
- release requirements
- any unresolved setup risk
