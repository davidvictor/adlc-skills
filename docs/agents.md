---
id: adlc-doc-agents
type: guide
status: active
owner: ADLC
---

# Agent Targets

ADLC installs into selected agent targets through one `init` command.

```bash
adlc init /path/to/project --agents codex,claude,hermes --mcp github,playwright
```

List supported targets:

```bash
adlc agents
adlc agents --json
```

## Codex

`codex` installs:

- ADLC skills into `.codex/skills/`
- Codex native agent TOMLs into `.codex/agents/`
- managed Codex config into `.codex/config.toml`
- selected MCP blocks into `.codex/config.toml`

Codex is the main build, review, test, and commit execution target.

## Claude

`claude` installs:

- ADLC skills into `.claude/skills/`
- selected MCP config into `.mcp.json`

Claude agent definitions will be added when they are intentionally authored for ADLC.

## Hermes

`hermes` installs:

- `.hermes/config.yaml`
- `.hermes/kanban.json`
- `.hermes/workstreams/`
- `.hermes/inbox/`

Hermes is the managed workstream target. ADLC projects grounded epics into Hermes cards; Hermes owns board progression after handoff.

## Managed State

ADLC records managed file hashes in `.adlc/managed-state.json`.

Use:

```bash
adlc status /path/to/project --strict
adlc update /path/to/project
adlc doctor /path/to/project
adlc uninstall /path/to/project --agents codex,claude,hermes
```
