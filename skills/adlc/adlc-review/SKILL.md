---
name: adlc-review
description: Review staged or working-tree changes with ADLC context and read-only gate output.
---

# ADLC Review

Use this for correctness, regression, maintainability, and risk review.

## Process

1. Pin the diff target.
2. Read the active plan, `.adlc/RULES.md`, and architecture.
3. Review behavior first, then maintainability, security, docs, and release risk.
4. Prefer `review-sidecar`, `security-sidecar`, and `rules-sidecar` for independent read-only checks when available.
5. Lead with blocking findings. Say clearly when there are none.

## Output

End with:

```json
{
  "adlc_gate_result": {
    "gate": "review",
    "status": "pass|warn|fail",
    "findings": []
  }
}
```
