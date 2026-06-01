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
Lane: coordinator
Milestone: none
Depends on: none
Write scope: bin/adlc.js, scripts/test-adlc-cli.sh
Interfaces touched: CLI, config
Risk: medium

### Goal

Track project Codex config as a managed artifact.

### Acceptance Criteria

- `adlc init --agents codex` writes `.codex/config.toml`.
- Status detects config drift.
- ADLC MCP blocks do not count as drift.

## Task 0002 - Agent Docs

Status: pending
Owner: worker:docs
Lane: worker
Milestone: none
Depends on: 0001
Write scope: README.md, docs/agents.md, docs/subagents.md
Interfaces touched: docs
Risk: low

### Goal

Document managed Codex config behavior.

### Acceptance Criteria

- Docs name the installed file and drift behavior.
- Validation covers the docs link.
```

## Workstream Escalation

Use `adlc-workstream` when the plan needs milestone state or Codex goal continuity:

```markdown
# Payments Platform Modernization

Granularity: workstream
Codex goal objective: Modernize the payments platform through staged, verified milestone slices.

Milestones:
- M0001: Stabilize current payment contract and regression coverage.
- M0002: Introduce the new provider abstraction behind existing behavior.
- M0003: Migrate checkout and billing flows with release gates.

Next action:
- Create `.adlc/workstreams/payments-platform-modernization/`.
```
