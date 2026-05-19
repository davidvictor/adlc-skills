---
name: adlc-verify
description: Verify implementation completeness against ADLC plans, rules, and repo behavior.
---

# ADLC Verify

Use this after implementation and before review or commit.

## Process

1. Read the active plan, `.adlc/RULES.md`, architecture, and git diff.
2. Map each plan task and acceptance criterion to evidence.
3. Run the strongest practical repo checks.
4. Look for leftover TODOs, env/config drift, skipped tests, stale docs, and plan-vs-code gaps.
5. Use strict mode before merge or release.

## Output

End with:

```json
{
  "adlc_gate_result": {
    "gate": "verify",
    "status": "pass|warn|fail",
    "blocking_gaps": [],
    "next_checks": []
  }
}
```
