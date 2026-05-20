# ADLC Plan Examples

## Fast Plan

Use `paths.plan` for small, single-thread work:

```markdown
# Fix Missing Config Guard

## Goal

Prevent startup failure when the optional config file is absent.

## Steps

1. Inspect the existing config loader and callers.
2. Add a missing-file branch that returns defaults.
3. Add or update focused tests.
4. Run the smallest reliable verification command.

## Acceptance Criteria

- Missing config no longer throws.
- Existing config behavior is unchanged.
- Verification command passes.
```

## Full Plan

Use `paths.plans/<slug>.md` when the work has dependencies or parallelizable tasks:

```markdown
# Agent Installer Hardening

## Task 0001 - Managed Config State

Status: pending
Owner: coordinator
Depends on: none
Write scope: bin/adlc.js, scripts/test-adlc-cli.sh

### Goal

Track project Codex config as a managed artifact.

### Acceptance Criteria

- `adlc init --agents codex` writes `.codex/config.toml`.
- Status detects config drift.
- ADLC MCP blocks do not count as drift.

## Task 0002 - Agent Docs

Status: pending
Owner: worker:docs
Depends on: 0001
Write scope: README.md, docs/agents.md, docs/subagents.md

### Goal

Document managed Codex config behavior.

### Acceptance Criteria

- Docs name the installed file and drift behavior.
- Validation covers the docs link.
```
