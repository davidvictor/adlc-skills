---
id: adlc-project-architecture
type: architecture
status: active
owner: ADLC
---

# Architecture

ADLC is organized as a small framework package rather than a monolithic agent runner.

## Components

- CLI: `bin/adlc.js` owns runtime installation, managed state, MCP config, local extensions, config resolution, workstream scaffolding, and artifact audits.
- Skills: `skills/adlc/*/SKILL.md` defines the public lifecycle command surface. Each skill owns a narrow artifact or workflow responsibility.
- Skill assets: skill `references/`, `templates/`, `tests/`, and `agents/openai.yaml` provide progressive context, fixtures, and runtime metadata.
- Codex agents: `subagents/codex/agents/*.toml` defines coordinators, bounded workers, and read-only sidecars.
- Target-project context: `.adlc/` is the default artifact root for config, descriptions, rules, plans, QA, loops, and workstreams.
- Docs: `docs/` records operator guidance, parity decisions, ADRs, and schema contracts.

## Lifecycle Flow

```text
setup -> grounded/explore -> architecture/roadmap/rules/reference
      -> plan -> optional workstream -> improve -> implement
      -> verify/rules/security/docs/QA gates -> review -> commit -> evolve
```

## Execution Model

Codex coordinators own orchestration. Workers receive bounded write scopes. Sidecars are read-only by default. Hermes is treated as an external executor lane for workstream handoff, not as an embedded ADLC runner.

## State Model

Long-running state must live in files, not chat memory. Managed install state lives in Codex home or target project `.adlc/managed-state.*.json`. Workstream state lives under `.adlc/workstreams/<slug>/`.

## Package Boundary

ADLC is currently private and intentionally not published to NPM. The package exposes `adlc` through `package.json` for local use, while install/update remains repo-local until distribution needs are proven.
