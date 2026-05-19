---
id: adlc-doc-extensions
type: guide
status: active
owner: ADLC
---

# Extensions

ADLC extensions are local workflow packs. They are deliberately smaller than AI Factory marketplace extensions.

## Commands

```bash
node bin/adlc.js extension validate extensions/marketplace/hello-adlc
node bin/adlc.js extension add extensions/marketplace/hello-adlc /path/to/project --runtime codex-project
node bin/adlc.js extension list /path/to/project
node bin/adlc.js extension remove hello-adlc /path/to/project --runtime codex-project
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

`skills` install custom skills into the selected runtime. `replaces` maps an extension skill directory to an ADLC base skill name and restores the packaged base skill on removal when safe. `injections` append or prepend marked content to installed skill files and are stripped on removal. `mcpServers` writes runtime MCP settings and removes those keys with the extension.

## Registry

Installed extension state is written to `.adlc/extensions/registry.json` in the target project.

## Limits

ADLC does not yet support remote extension fetching, dynamic extension CLI commands, extension-defined runtime registration, or extension update checks. Add those only for real extension needs.
