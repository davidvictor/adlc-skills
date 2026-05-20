---
id: adlc-doc-gate-result-schema
type: contract
status: active
owner: ADLC
---

# ADLC Gate Result Schema

ADLC quality gates keep their human-readable summary, then append one final machine-readable fenced block. Future orchestration must parse only the last `adlc-gate-result` block in a gate response.

Supported gates:

- `verify`
- `review`
- `rules`
- `security`

## Block Format

````markdown
```adlc-gate-result
{
  "schema_version": 1,
  "gate": "verify",
  "status": "fail",
  "blocking": true,
  "blockers": [
    {
      "id": "verify-task-1",
      "severity": "error",
      "file": "src/example.ts",
      "summary": "Required behavior is missing."
    }
  ],
  "affected_files": ["src/example.ts"],
  "suggested_next": {
    "command": "adlc-fix",
    "reason": "Blocking implementation gaps remain."
  }
}
```
````

## Fields

- `schema_version`: currently `1`.
- `gate`: one of `verify`, `review`, `rules`, or `security`.
- `status`: one of `pass`, `warn`, or `fail`.
- `blocking`: boolean; true when the gate should stop commit, merge, release, or the requested next lifecycle step.
- `blockers`: only findings that block the gate. Use an empty array for pass and non-blocking warnings.
- `blockers[].severity`: `error` or `warning`.
- `blockers[].file`: file path when a blocker is file-specific, otherwise omit or use `null`.
- `blockers[].summary`: concise blocker summary.
- `affected_files`: predictable top-level list of files evaluated or cited by the gate. Use `[]` when no files apply.
- `suggested_next.command`: one of `adlc-fix`, `adlc-rules`, `adlc-plan`, `adlc-implement`, `adlc-verify`, `adlc-security-checklist`, `adlc-review`, `adlc-commit`, or `null`.
- `suggested_next.reason`: short reason for the recommended next command.

## Pass Example

```adlc-gate-result
{
  "schema_version": 1,
  "gate": "review",
  "status": "pass",
  "blocking": false,
  "blockers": [],
  "affected_files": ["skills/adlc/adlc-review/SKILL.md"],
  "suggested_next": {
    "command": "adlc-commit",
    "reason": "Review found no blocking issues."
  }
}
```

## Warn Example

```adlc-gate-result
{
  "schema_version": 1,
  "gate": "verify",
  "status": "warn",
  "blocking": false,
  "blockers": [],
  "affected_files": ["README.md"],
  "suggested_next": {
    "command": "adlc-review",
    "reason": "Verification passed with non-blocking documentation follow-up."
  }
}
```
