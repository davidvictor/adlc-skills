---
id: adlc-doc-mcp
type: guide
status: active
owner: ADLC
---

# MCP

ADLC can configure known MCP server templates for selected agent targets.

List templates:

```bash
adlc mcp list
```

Configure or remove:

```bash
adlc mcp configure filesystem /path/to/project --agents codex,claude
adlc mcp remove filesystem /path/to/project --agents codex,claude
```

`adlc init` can configure MCP during setup:

```bash
adlc init /path/to/project --agents codex,claude,hermes --mcp github,playwright
```

## Templates

Templates live under `mcp/templates/`:

- `filesystem`
- `github`
- `postgres`
- `playwright`
- `chrome-devtools`

## Writers

- Codex writes marked TOML blocks into `.codex/config.toml`.
- Claude writes MCP entries into `.mcp.json`.
- Hermes does not configure MCP in the first public release.
