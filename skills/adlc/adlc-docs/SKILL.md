---
name: adlc-docs
description: Audit and update documentation artifacts that explain shipped ADLC-relevant behavior.
---

# ADLC Docs

Use this when documentation needs to be created, refreshed, or checked as part of a lifecycle change.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read the active plan, relevant code, configured architecture, configured rules, and existing docs.
3. Decide whether docs are required for the change or explicitly not needed.
4. Update docs closest to the behavior owner.
5. Add artifact frontmatter when the doc should be tracked by `adlc audit-artifacts`.
6. Avoid broad docs rewrites unless the plan calls for them.

## Output

Report changed docs, skipped docs with reasons, artifact IDs added or updated, and whether `adlc-verify` or `adlc-review` should re-run.
