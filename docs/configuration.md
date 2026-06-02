---
id: adlc-doc-configuration
type: guide
status: active
owner: ADLC
---

# Configuration

Target projects use `.adlc/config.yaml` to define artifact paths, workflow defaults, git policy, and selected agent targets.

Create it with:

```bash
adlc init /path/to/project --agents codex,claude --mcp github,playwright
```

Inspect the effective paths with:

```bash
adlc resolve-config /path/to/project
adlc resolve-config /path/to/project --json
```

## Write Contract

- `adlc` and the init command create the initial config.
- Operators may edit config manually.
- Lifecycle skills should read config and honor resolved paths.
- Skills should not rewrite config unless the requested task is specifically configuration work.

## Supported Shape

The current resolver intentionally supports a simple YAML subset: top-level sections with scalar key/value pairs. It is enough for the shipped template and avoids adding runtime dependencies.

Supported sections:

- `paths`
- `workflow`
- `git`
- `agents`
- `install`

## Path Resolution

Relative paths are resolved from the target project root. If a target project omits `.adlc/config.yaml`, the CLI falls back to the packaged template.

`paths.interviews` controls where `adlc-interview` writes context snapshots, transcripts, and clarified specs. The default is `.adlc/interviews`.

`paths.workstreams` controls where `adlc-workstream` and `adlc workstream` create long-running epic artifacts. The default is `.adlc/workstreams`.

`install.agents` records selected setup targets such as `codex,claude`.

`install.mcp` records MCP server templates selected during setup.

## Known Limits

- Nested YAML objects are not fully parsed yet.
- Branch/base-branch inference is not automatic yet.
- Rules hierarchy is conventional rather than deeply modeled.
