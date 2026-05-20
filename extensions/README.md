# ADLC Extensions

ADLC extensions are local workflow packs: a directory with `extension.json`, optional skills, optional replacement skills, optional injections, optional agent files, and optional MCP server templates.

Use the CLI:

```bash
adlc extension validate extensions/marketplace/hello-adlc
adlc extension add extensions/marketplace/hello-adlc /path/to/project --agents codex,claude
adlc extension list /path/to/project
adlc extension remove hello-adlc /path/to/project
```

Installed extension registry state lives under `.adlc/extensions/registry.json` in the target project.
