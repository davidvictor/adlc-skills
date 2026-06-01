# ADLC Task Format

Use this format for full plans under the configured `paths.plans` directory.

```markdown
# Plan Title

## Objective

Describe the user-visible or operator-visible outcome.

## Constraints

- Evidence, non-goals, release constraints, and risky assumptions.

## Task Graph

## Task 0001 - Short Action Name

Status: pending
Owner: coordinator | worker:<name> | human
Lane: coordinator | worker | parallel | human-gated
Milestone: none | M0001
Depends on: none | 0001, 0002
Write scope: file/path, module/path
Interfaces touched: API, schema, UI, job, config, docs, none
Risk: low | medium | high

### Goal

One paragraph describing the behavioral outcome.

### Acceptance Criteria

- Observable criterion with evidence expectation.
- Test or manual verification that proves the change.

### Implementation Notes

- Existing patterns to follow.
- Known constraints or non-goals.
- Rollback or release notes when relevant.

### Verification

- Command or inspection to run.
- Expected result.

### Commit Checkpoint

- Commit subject:
- Files expected:
```

Rules:

- Use sequential four-digit task IDs for full plans.
- Give every worker or parallel task a disjoint write scope.
- Put dependency edges in the task, not only in prose.
- Keep acceptance criteria observable enough for `adlc-verify`.
- Split a task when it spans unrelated subsystems, cannot be verified in one pass, or would create a mixed commit.
- Promote the plan to `adlc-workstream` when it needs milestones, multi-sprint state, or Codex goal continuity.
