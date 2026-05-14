# Agent Brief Template

```markdown
# Agent Brief: <Title>

## Category

bug / enhancement / chore / research / design / debt

## Summary

One-line description of the required outcome.

## Current Behavior

What happens now, including the user/operator impact.

## Desired Behavior

What should be true after the work is complete.

## Scope

- Included:
- Key interfaces or contracts:
- Constraints:

## Non-Goals

- Adjacent work not included:

## Edge Cases And Blocked States

- Unsupported input:
- Missing access:
- Failure mode:

## Acceptance Criteria

- [ ] Specific, independently verifiable criterion
- [ ] Edge case or blocked state is handled
- [ ] Verification evidence is named

## Verification

Commands, browser checks, screenshots, fixture runs, or manual evidence expected.

## Dependencies

None, or links to decisions, issues, PRDs, ADRs, prototypes, or credentials.
```

Write briefs as behavioral contracts. Avoid line numbers and brittle file-by-file instructions unless a file path is itself the public contract.
