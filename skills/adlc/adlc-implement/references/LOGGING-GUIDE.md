# ADLC Implementation Logging Guide

Prefer compact status updates in the active plan or loop artifact.

Use this shape when a durable implementation note is useful:

```markdown
## Implementation Note - Task 0001

Status: done | blocked | partial
Changed files:
- path/to/file

Verification:
- command: `npm test`
- result: passed

Sidecar findings:
- none | finding summary

Residual risk:
- none | short note
```

Do not duplicate git diff output. Capture decisions, evidence, blockers, and follow-up ownership.
