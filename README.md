# ADLC

ADLC is David Victor's agent-driven development lifecycle, rebuilt on the useful parts of the AI Factory architecture.

This repo is a lean command pipeline with ADLC-owned artifacts and Codex-native agents. The goal is not to mirror every upstream AI Factory feature. The goal is the smallest system that matches how David actually works:

- repo-local context and plans under `.adlc/`
- a short command surface that routes work instead of a broad menu of lifecycle skills
- native Codex coordinators, workers, and read-only sidecars
- explicit artifact ownership so agents do not fight over the same files
- implementation that ends in verification, review, commit readiness, and a clear handoff

The upstream comparison source is [lee-to/ai-factory](https://github.com/lee-to/ai-factory), especially its [getting started](https://github.com/lee-to/ai-factory/blob/2.x/docs/getting-started.md), [workflow](https://github.com/lee-to/ai-factory/blob/2.x/docs/workflow.md), and [subagents](https://github.com/lee-to/ai-factory/blob/2.x/docs/subagents.md) docs.

## Command Surface

Use these skills as the public interface:

1. `adlc` - initialize or refresh `.adlc/` context.
2. `adlc-explore` - investigate options without committing to a plan.
3. `adlc-grounded` - answer from evidence only when guessing is unacceptable.
4. `adlc-plan` - create fast or full implementation plans.
5. `adlc-improve` - tighten an existing plan before implementation.
6. `adlc-implement` - execute a plan with Codex coordinators, workers, and sidecars.
7. `adlc-verify` - prove completion against plan, rules, and repo behavior.
8. `adlc-review` - review diffs for correctness, maintainability, and risk.
9. `adlc-commit` - prepare conventional commits from staged work.
10. `adlc-fix` - diagnose, fix, and record a learning patch.
11. `adlc-evolve` - turn patches and repeated findings into durable rules or skill updates.

Everything else has been removed or folded into these commands.

## Workflow

```text
adlc
  -> adlc-explore or adlc-grounded
  -> adlc-plan
  -> adlc-improve
  -> adlc-implement
  -> adlc-verify
  -> adlc-review
  -> adlc-commit
  -> adlc-evolve when there is reusable learning
```

Bug work can enter through `adlc-fix`, then continue to `adlc-verify`, `adlc-review`, and `adlc-commit`.

## Artifact Ownership

Default target-project paths:

```text
.adlc/
  config.yaml
  DESCRIPTION.md
  ARCHITECTURE.md
  RULES.md
  RESEARCH.md
  PLAN.md
  plans/
  fixes/
  patches/
  skill-context/
  qa/
```

Ownership is strict:

- `adlc` owns setup context.
- `adlc-explore` owns research only when explicitly asked to persist it.
- `adlc-plan` owns plan files.
- `adlc-improve` may edit plan files.
- `adlc-implement` owns code changes for the selected plan tasks.
- `adlc-verify`, `adlc-review`, and sidecars are read-only by default.
- `adlc-fix` owns fix plans and patches.
- `adlc-evolve` owns skill-context and proposed ADLC updates.

## Codex Native Agents

Codex agents live in `subagents/codex/agents/`:

- `plan-coordinator`
- `plan-polisher`
- `implement-coordinator`
- `implement-worker`
- `review-sidecar`
- `security-sidecar`
- `rules-sidecar`
- `docs-auditor`
- `best-practices-sidecar`
- `commit-preparer`

The coordinator agents own orchestration. Worker agents own bounded edits. Sidecars are read-only unless their file says otherwise.

## Install For Local Codex

```bash
scripts/install-codex-adlc.sh
```

This syncs skills into `${CODEX_HOME:-~/.codex}/skills` and Codex agent TOML files into `${CODEX_HOME:-~/.codex}/agents`.

## Initialize A Project

```bash
scripts/init-adlc-project.sh /path/to/project
```

This creates the `.adlc/` scaffold and preserves existing project context files.

## Package Status

The repo has private package metadata as `@davidvictor/adlc` so NPM scripts can wrap validation and install tasks. It is intentionally not publishable yet; ADLC needs managed update state, fixture-backed tests, and a real CLI before NPM publication makes the system simpler.

## Validation

```bash
scripts/list-adlc.sh
scripts/validate-adlc.sh
```

Validation fails if old upstream-prefixed skill paths remain, if the plugin manifest points at removed skills, if required Codex agents are missing, if package metadata is unsafe to publish accidentally, or if the public docs drift from the ADLC command surface.

## Refactor Record

See [docs/ai-factory-port-audit.md](./docs/ai-factory-port-audit.md) for the AI Factory comparison, removal/adaptation decisions, and the concrete replacement path.
