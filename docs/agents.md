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

Codex is the Hermes board operator for ADLC workstreams. Codex prepares the
source workstream, syncs the Hermes Kanban, and starts or assigns the requested
tasks. Hermes tasks should run on a Codex GPT-5.5 profile with xhigh reasoning
unless a project override says otherwise. Worktree use is configurable and
should be asked for unless already required by config or user instruction.

ADLC stop commands are task-scoped. Do not stop Hermes gateway, daemon,
scheduler, or other global services unless the operator explicitly names that
service.

## Managed State

ADLC records managed file hashes in `.adlc/managed-state.json`.

Use:

```bash
adlc status /path/to/project --strict
adlc update /path/to/project
adlc doctor /path/to/project
adlc uninstall /path/to/project --agents codex,claude,hermes
```
