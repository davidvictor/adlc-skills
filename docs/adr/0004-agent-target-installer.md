---
id: adlc-adr-0004-agent-target-installer
type: adr
status: accepted
owner: ADLC
---

# ADR 0004: ADLC Uses Agent Target Installation

Status: accepted

## Context

ADLC needs a public installation model that is short, clear, and usable across Codex, Claude, and Hermes without exposing implementation-specific install commands.

## Decision

Publish the package as `adlc-cli` and keep the binary command as `adlc`.

Use one setup command:

```bash
adlc init --agents codex,claude,hermes --mcp github,playwright
```

The installer writes agent-specific files through adapters:

- `codex` owns `.codex/skills/`, `.codex/agents/`, `.codex/config.toml`, and Codex MCP blocks.
- `claude` owns `.claude/skills/` and Claude MCP entries in `.mcp.json`.
- `hermes` owns `.hermes/config.yaml`, `.hermes/kanban.json`, `.hermes/workstreams/`, and `.hermes/inbox/`.

Managed hashes live in one project-local `.adlc/managed-state.json`.

## Consequences

The public command surface stays small:

- `init`
- `agents`
- `update`
- `status`
- `doctor`
- `uninstall`
- `mcp`
- `extension`
- `workstream`

Agent adapters can grow independently while the operator-facing setup flow stays stable.
