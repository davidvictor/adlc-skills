---
name: adlc-verify
description: Verify implementation completeness against ADLC plans, rules, and repo behavior.
---

# ADLC Verify

Use this after implementation and before review or commit.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read the active plan, configured rules, architecture, and git diff.
3. Map each plan task and acceptance criterion to evidence.
4. Run the strongest practical repo checks.
5. Look for leftover TODOs, env/config drift, skipped tests, stale docs, and plan-vs-code gaps.
6. Use strict mode before merge or release.

## Output

End with a final parseable `adlc-gate-result` fenced block:

```adlc-gate-result
{
  "schema_version": 1,
  "gate": "verify",
  "status": "pass|warn|fail",
  "blocking": false,
  "blockers": [],
  "affected_files": [],
  "suggested_next": {
    "command": "adlc-review|adlc-fix|null",
    "reason": "Short reason."
  }
}
```
