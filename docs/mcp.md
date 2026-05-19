---
id: adlc-doc-mcp
type: guide
status: active
owner: ADLC
---

# MCP

ADLC can configure known MCP server templates for supported runtimes.

List templates:

```bash
node bin/adlc.js mcp list
```

Configure or remove:

```bash
node bin/adlc.js mcp configure filesystem /path/to/project --runtime codex-project
node bin/adlc.js mcp remove filesystem /path/to/project --runtime codex-project
node bin/adlc.js mcp configure filesystem /path/to/project --runtime claude-project
```

## Templates

Templates live under `mcp/templates/`:

- `filesystem`
- `github`
- `postgres`
- `playwright`
- `chrome-devtools`

## Runtime Writers

- Codex runtimes write marked TOML blocks.
- Claude project runtime writes `.mcp.json`.
- Universal runtime has no MCP settings target.

