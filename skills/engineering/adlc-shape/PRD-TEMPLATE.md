# PRD Template

```markdown
# PRD: <Name>

## Overview

Short description of the intended outcome.

## Problem Statement

The current pain or failure mode, from the user's perspective.

## Target Users

Primary and secondary users. Include non-users when useful.

## Goals

- Measurable or observable outcome 1
- Measurable or observable outcome 2

## Non-Goals

- Explicit boundary 1
- Explicit boundary 2

## User Stories

1. As a <actor>, I want <capability>, so that <benefit>.

## Implementation Decisions

- Modules or interfaces expected to change
- API, schema, data, auth, runtime, or UI decisions
- Important trade-offs
- Prototype-derived decisions, if any

Avoid brittle file paths unless they are the actual public contract.

## Testing Decisions

- What behavior should be tested
- Which interfaces are the test surface
- Prior art in the repo
- What not to test

## Acceptance Criteria

- [ ] Specific, testable criterion
- [ ] Unsupported input or blocked state is handled
- [ ] Verification evidence is named

## Rollout And Rollback

How the change ships, and how it can be backed out.

## Risks

Known technical, product, data, safety, or operational risks.

## Open Questions

Only questions that materially affect scope, safety, or value.
```
