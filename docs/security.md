---
id: adlc-doc-security
type: guide
status: active
owner: ADLC
---

# Security

ADLC is a local workflow framework. Its security posture is built around narrow writes, managed state, local extension validation, and explicit runtime targets.

## Core Rules

- Use `adlc-security-checklist` for standalone security gates on plans, diffs, extensions, MCP templates, and release candidates.
- Do not install untrusted extensions.
- Validate extension manifests before install.
- Keep secrets out of git and out of ADLC docs.
- Treat MCP configuration as code execution because MCP servers launch commands.
- Use `status --strict` before update when local runtime artifacts may have been edited.
- Use `--force` only when intentionally overwriting managed artifacts.

## Extension Safety

Extension paths must stay inside the extension directory. ADLC validates skill directories and agent file sources before installing.

## MCP Safety

MCP templates can include commands and environment variables. Review templates before configuring them, especially for servers that access files, browsers, GitHub, or databases.

## Managed State

Managed state protects ADLC-installed skills and agents from silent overwrites. Drift blocks update unless `--force` is provided.
