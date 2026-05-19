# ADLC Agent Guide

This repository is the local ADLC skill and agent package. It uses an AI Factory-style architecture, but ADLC is the public name and command namespace.

## Canonical Guidance

`AGENTS.md` is the canonical guide. `CLAUDE.md` only points here.

## Architecture Rules

- Public skills live under `skills/adlc/`.
- Public skill names are `adlc` or `adlc-*`.
- Codex native agents live under `subagents/codex/agents/`.
- Target-project runtime artifacts live under `.adlc/` unless a repo explicitly overrides paths.
- Do not add old phase-skill conventions, Hermes-specific runners, or broad tracker abstractions.
- Keep the command surface small. Add a new skill only when it cannot be expressed as a mode of an existing `adlc-*` command.

## ADLC Command Rules

- `adlc-plan` owns plans.
- `adlc-improve` refines plans.
- `adlc-implement` executes plans and coordinates Codex agents.
- `adlc-verify`, `adlc-review`, and sidecars are read-only gates unless explicitly promoted to a fix task.
- `adlc-fix` diagnoses and repairs bugs, then writes a patch note.
- `adlc-evolve` converts repeated learning into rules, skill-context, or this repo's source changes.

## Skill Writing Standards

- Keep `SKILL.md` concise and operational.
- Prefer exact artifact ownership over explanatory essays.
- Ask only when the answer changes plan scope, risk, release posture, or destructive actions.
- Use native Codex agents for independent bounded work and read-only sidecars.
- Preserve unrelated user work.
- Keep output contracts machine-readable where orchestration depends on them.

## Validation

Before closeout, run:

```bash
scripts/validate-adlc.sh
```

Use `scripts/list-adlc.sh` to inspect the public skill set.

Validation must pass before claiming the package is internally consistent.

## Durable Decisions

Record hard-to-reverse ADLC decisions in `docs/adr/`. Use ADRs for command surface changes, agent contract changes, artifact path changes, packaging decisions, or validation policy changes.
