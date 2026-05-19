# ADR 0001: ADLC Uses An AI Factory-Style Core

Status: accepted

Superseded in part by [ADR 0002](./0002-adlc-framework-foundation.md), which closes several items listed here as "not ported yet."

## Context

The previous ADLC package grew into many public phase skills. That made the lifecycle expressive, but it also made routing noisy: agents had to choose among setup, probe, anchor, shape, slice, sprint, build, audit, close, prove, release, handoff, and Hermes-specific runner skills before doing useful work.

AI Factory 2.x provides a cleaner shape: a small command pipeline, command-owned artifacts, project config, plan-first implementation, native runtime agents, and read-only quality sidecars.

## Decision

Keep the name ADLC and rebuild it around the useful AI Factory concepts:

- `adlc` and `adlc-*` skills are the public command surface.
- `.adlc/` is the default target-project artifact root.
- `skills/adlc/` owns skill definitions and OpenAI/Codex metadata.
- `subagents/codex/agents/` owns native Codex agent TOML files.
- `scripts/install-codex-adlc.sh` syncs local Codex skills and agents.
- `scripts/init-adlc-project.sh` creates the target-project `.adlc/` context scaffold.
- `scripts/validate-adlc.sh` is the required consistency gate.

## Ported From AI Factory

- command-scoped artifact ownership
- optional exploration and grounded-answer gates
- fast/full planning modes
- plan improvement before implementation
- implementation coordinator plus bounded workers
- read-only sidecars for review, security, rules, docs, best practices, and commit preparation
- machine-readable gate result blocks
- patch-to-evolve learning loop
- package metadata for future install/update automation

## Intentionally Not Ported Yet

- public NPM CLI with `init`, `update`, `upgrade`, and extension commands
- multi-runtime install support beyond local Codex
- MCP auto-configuration
- extension marketplace mechanics
- Docker, CI, docs-site, QA, reference, roadmap, rules, security-checklist, and reflex-loop skills as standalone public commands
- artifact metadata auditing CLI
- managed hash tracking for installed skills, agents, and config files

## Consequences

ADLC is an opinionated fork, not upstream AI Factory compatibility. It keeps the lifecycle name and David-specific workflow constraints while adopting the factory architecture underneath.

The current package is strong enough for local Codex use. It is not yet a distributed framework with a durable package/update protocol.
