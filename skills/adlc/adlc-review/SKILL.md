---
name: adlc-review
description: Review staged or working-tree changes with ADLC context and read-only gate output.
---

# ADLC Review

Use this for correctness, regression, maintainability, and risk review.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Pin the diff target.
3. Read the active plan, configured rules, and architecture.
4. Review behavior first, then maintainability, security, docs, and release risk.
5. Prefer `review-sidecar`, `security-sidecar`, and `rules-sidecar` for independent read-only checks when available.
6. Lead with blocking findings. Say clearly when there are none.

## Output

End with a final parseable `adlc-gate-result` fenced block:

```adlc-gate-result
{
  "schema_version": 1,
  "gate": "review",
  "status": "pass|warn|fail",
  "blocking": false,
  "blockers": [],
  "affected_files": [],
  "suggested_next": {
    "command": "adlc-commit|adlc-fix|null",
    "reason": "Short reason."
  }
}
```
