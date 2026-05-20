---
id: adlc-doc-subagents
type: guide
status: active
owner: ADLC
---

# Subagents

ADLC uses native Codex agents for bounded parallel work and independent read-only checks.

`adlc init --agents codex` copies the bundled Codex TOML files into `.codex/agents/` and copies managed Codex defaults into `.codex/config.toml`. ADLC tracks managed files in `.adlc/managed-state.json`, while ignoring ADLC MCP blocks during Codex config hash checks so MCP setup remains independently configurable.

## Coordinators

- `plan-coordinator`: structures non-trivial plans.
- `implement-coordinator`: owns implementation orchestration.

## Model Standard

All bundled Codex agents use `gpt-5.5`.

Reasoning effort is tiered by responsibility:

- `medium`: coordinators and lightweight read-only sidecars.
- `high`: bounded implementation workers, plan polish, review, and security checks.

## Workers

- `implement-worker`: performs bounded, disjoint code edits under coordinator direction.

## Sidecars

- `review-sidecar`: independent correctness and regression review.
- `security-sidecar`: security and trust-boundary review.
- `rules-sidecar`: rules compliance review.
- `docs-auditor`: documentation impact review.
- `best-practices-sidecar`: local pattern and maintainability review.
- `commit-preparer`: commit grouping and message review.
- `plan-polisher`: second-pass plan refinement.

## Rules

- Sidecars are read-only by default.
- Workers must receive explicit ownership of files or modules.
- Do not delegate urgent blocking work when the coordinator needs the result before moving.
- Integrate worker results before claiming completion.
