---
id: adlc-doc-runtimes
type: guide
status: active
owner: ADLC
---

# Runtimes

ADLC supports a small runtime registry instead of AI Factory's broad runtime matrix.

List runtimes:

```bash
node bin/adlc.js runtimes
```

## Supported Runtimes

- `codex-home`: installs into `${CODEX_HOME:-~/.codex}` with Codex agent TOMLs.
- `codex-project`: installs into `.codex/` inside a target project.
- `claude-project`: installs skills into `.claude/skills` and writes `.mcp.json` for MCP.
- `universal-project`: installs skills into `.agents/skills`.

## Install

```bash
node bin/adlc.js install /path/to/project --runtime codex-project
node bin/adlc.js install /path/to/project --runtime claude-project
node bin/adlc.js status /path/to/project --runtime codex-project --strict
```

Runtime managed state is project-local under `.adlc/managed-state.<runtime>.json`, except `codex-home`, which uses `${CODEX_HOME:-~/.codex}/adlc-managed-state.json`.

`codex-project` also installs and tracks the bundled Codex runtime config from `subagents/codex/config.toml` to `.codex/config.toml`. ADLC-owned MCP blocks in that TOML file are normalized out of managed hashes so MCP auto-config does not appear as local drift.
