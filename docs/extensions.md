---
id: adlc-doc-extensions
type: guide
status: active
owner: ADLC
---

# Extensions

ADLC extensions are local workflow packs that can add skills, replace packaged skills, inject content into installed skills, install agent files, and add MCP server entries.

## Commands

```bash
adlc extension validate extensions/marketplace/hello-adlc
adlc extension add extensions/marketplace/hello-adlc /path/to/project --agents codex,claude
adlc extension list /path/to/project
adlc extension remove hello-adlc /path/to/project
```

## Manifest

Extension manifests use `extension.json`. The schema lives at [schemas/extension.schema.json](../schemas/extension.schema.json).

Supported fields:

- `name`
- `version`
- `description`
- `skills`
- `replaces`
- `injections`
- `agentFiles`
- `mcpServers`

`skills` install custom skills into selected agents that support skills. `replaces` maps an extension skill directory to an ADLC base skill name and restores the packaged base skill on removal when safe. `injections` append or prepend marked content to installed skill files and are stripped on removal. `agentFiles` can target a specific agent. `mcpServers` writes MCP settings for selected agents that support MCP and removes those keys with the extension.

## Registry

Installed extension state is written to `.adlc/extensions/registry.json` in the target project.

## Limits

ADLC does not yet support remote extension fetching, dynamic extension CLI commands, or extension update checks. Add those only for real extension needs.
