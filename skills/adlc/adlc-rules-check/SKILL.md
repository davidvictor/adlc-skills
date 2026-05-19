---
name: adlc-rules-check
description: Run a read-only ADLC rules compliance gate for plans, diffs, or release candidates.
---

# ADLC Rules Check

Use this when a plan, diff, or release candidate needs a standalone rules gate.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Pin the target: plan path, staged diff, working tree diff, or git ref.
3. Read configured rules, architecture, roadmap, and active plan context.
4. Check for direct rule violations, missing rule-driven tests, stale docs, and scope drift.
5. Stay read-only. Route fixes to `adlc-fix`, `adlc-plan`, or `adlc-rules`.
6. Lead with blocking violations.

## Output

End with a final parseable `adlc-gate-result` fenced block:

```adlc-gate-result
{
  "schema_version": 1,
  "gate": "rules",
  "status": "pass|warn|fail",
  "blocking": false,
  "blockers": [],
  "affected_files": [],
  "suggested_next": {
    "command": "adlc-fix|adlc-rules|adlc-commit|null",
    "reason": "Short reason."
  }
}
```
