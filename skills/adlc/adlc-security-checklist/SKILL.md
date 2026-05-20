---
name: adlc-security-checklist
description: Run a read-only ADLC security gate for secrets, trust boundaries, and unsafe workflow changes.
---

# ADLC Security Checklist

Use this when a plan, diff, extension, MCP configuration, release candidate, or workflow change needs a standalone security gate.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Pin the target: plan, diff, extension directory, MCP template, agent install, or release candidate.
3. Read architecture, rules, configured security references, and relevant source files.
4. Inspect secrets, auth, authorization, prompt/data injection, path traversal, command execution, dependency/install behavior, and external integrations.
5. Stay read-only. Route fixes to `adlc-fix`, `adlc-rules`, `adlc-plan`, or `adlc-implement`.
6. Lead with exploitable or operationally meaningful findings.

## Output

End with a final parseable `adlc-gate-result` fenced block:

```adlc-gate-result
{
  "schema_version": 1,
  "gate": "security",
  "status": "pass|warn|fail",
  "blocking": false,
  "blockers": [],
  "affected_files": [],
  "suggested_next": {
    "command": "adlc-fix|adlc-rules|adlc-plan|adlc-commit|null",
    "reason": "Short reason."
  }
}
```
