# Out-Of-Scope Records

Write durable scope memory only for real strategic rejections, not temporary priority calls.

## When To Write

Use an out-of-scope record when:

- the request is an enhancement or design change
- the state is `wontfix`
- the reason is expected to remain true
- future duplicate requests would benefit from the context

Use `deferred` instead when the decision is "not now."

## Location

Default:

```text
.out-of-scope/<concept>.md
```

If the repo's ADLC operating contract names another location, use that.

## Format

```markdown
# <Concept>

## Decision

This is out of scope.

## Reason

Durable explanation grounded in product scope, architecture, cost, risk, or strategy.

## Prior Requests

- <issue, PRD, discussion, or local draft link>

## Reconsider If

Concrete condition that would make the decision worth reopening.
```

Do not write vague reasons like "low priority" or "not worth it."
