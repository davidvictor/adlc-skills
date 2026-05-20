---
id: adlc-doc-getting-started
type: guide
status: active
owner: ADLC
---

# Getting Started

ADLC provides skills, agent-target installers, project artifacts, and a small CLI so agent work can move from context to plan to implementation to gates without inventing process each time.

## Install

```bash
npm install -g adlc-cli
```

The package installs the `adlc` command.

## Initialize A Project

```bash
adlc init /path/to/project --agents codex,claude,hermes --mcp github,playwright
adlc status /path/to/project --strict
```

This creates `.adlc/`, installs the selected agent targets, configures selected MCP servers, and records managed hashes in `.adlc/managed-state.json`.

Run without a global install:

```bash
npx adlc-cli init /path/to/project --agents codex,claude,hermes --mcp filesystem
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

## Workstream Handoff

```bash
adlc workstream create project-automation /path/to/project --executor either
adlc workstream sync project-automation /path/to/project --agent hermes
```

Hermes receives cards under `.hermes/workstreams/`, a board at `.hermes/kanban.json`, and an inbox handoff under `.hermes/inbox/`.

## Verify The Package

```bash
npm run test:cli
npm run test:skill-fixtures
npm run validate
npm run pack:dry-run
```
