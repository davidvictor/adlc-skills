---
id: adlc-doc-getting-started
type: guide
status: active
owner: ADLC
---

# Getting Started

ADLC is David's agent-driven development lifecycle. It provides skills, Codex agents, project artifacts, and a small CLI so agents can move from context to plan to implementation to gates without inventing process each time.

## Install Locally

From the ADLC repo:

```bash
node bin/adlc.js install-codex
node bin/adlc.js status --strict
```

This installs ADLC skills into `${CODEX_HOME:-~/.codex}/skills`, installs Codex agent TOMLs into `${CODEX_HOME:-~/.codex}/agents`, and records managed hashes in `${CODEX_HOME:-~/.codex}/adlc-managed-state.json`.

## Initialize A Project

```bash
node bin/adlc.js init /path/to/project
node bin/adlc.js resolve-config /path/to/project
```

This creates the `.adlc/` context root with config, description, architecture, rules, plans, patches, references, QA, and loop directories.

For a long-running epic, create a workstream scaffold:

```bash
node bin/adlc.js workstream create <slug> /path/to/project --executor either
```

## Use The Lifecycle

Common flow:

```text
adlc
adlc-explore or adlc-grounded
adlc-roadmap / adlc-rules / adlc-reference when needed
adlc-plan
adlc-workstream for long-running epics
adlc-improve
adlc-implement
adlc-verify
adlc-rules-check / adlc-docs / adlc-qa when needed
adlc-review
adlc-commit
adlc-evolve when reusable learning exists
```

Bug work can start at `adlc-fix`, then move through verify, review, and commit.

## Verify The Package

```bash
bash scripts/test-adlc-cli.sh
node bin/adlc.js validate
node bin/adlc.js audit-artifacts --strict
```

These checks cover the CLI, runtime install, MCP configuration, extension mechanics, artifact audit, managed status, and package consistency.
