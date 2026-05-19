---
id: adlc-doc-artifact-audit
type: guide
status: active
owner: ADLC
---

# Artifact Audit

`audit-artifacts` checks markdown artifacts for lightweight metadata and broken relationships.

Run:

```bash
node bin/adlc.js audit-artifacts
node bin/adlc.js audit-artifacts --strict
node bin/adlc.js audit-artifacts --json docs README.md AGENTS.md
```

## Frontmatter

Tracked artifacts should include:

```yaml
---
id: adlc-doc-example
type: guide
status: active
owner: ADLC
depends_on: [other-artifact-id]
---
```

Supported relationship fields:

- `depends_on`
- `affects`
- `implements`
- `verifies`
- `documents`
- `supersedes`

## Checks

The audit reports:

- missing explicit audit targets
- targets outside the project boundary
- duplicate IDs
- missing owner/status/type
- references to missing artifact IDs

