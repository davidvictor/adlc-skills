# ADLC Extensions

ADLC extensions are local workflow packs. They are intentionally simpler than AI Factory marketplace extensions: a directory with `extension.json`, optional skills, optional replacement skills, optional injections, optional runtime agent files, and optional MCP server templates.

Use the CLI:

```bash
node bin/adlc.js extension validate extensions/marketplace/hello-adlc
node bin/adlc.js extension add extensions/marketplace/hello-adlc /path/to/project --runtime codex-project
node bin/adlc.js extension list /path/to/project
node bin/adlc.js extension remove hello-adlc /path/to/project --runtime codex-project
```

Installed extension registry state lives under `.adlc/extensions/registry.json` in the target project.
