# ADLC Task Format

Use this format for full plans under the configured `paths.plans` directory.

```markdown
## Task 0001 - Short Action Name

Status: pending
Owner: coordinator | worker:<name> | human
Depends on: none | 0001, 0002
Write scope: file/path, module/path
Risk: low | medium | high

### Goal

One paragraph describing the behavioral outcome.

### Acceptance Criteria

- Observable criterion with evidence expectation.
- Test or manual verification that proves the change.

### Implementation Notes

- Existing patterns to follow.
- Known constraints or non-goals.

### Verification

- Command or inspection to run.
- Expected result.
```

Rules:

- Use sequential four-digit task IDs for full plans.
- Give every worker task a disjoint write scope.
- Put dependency edges in the task, not only in prose.
- Keep acceptance criteria observable enough for `adlc-verify`.
