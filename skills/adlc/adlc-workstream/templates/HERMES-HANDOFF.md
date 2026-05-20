---
id: {{WORKSTREAM_ID}}-hermes-handoff
type: handoff
status: active
owner: ADLC
documents: [{{WORKSTREAM_ID}}]
---

# Hermes Workstream Handoff

Hermes should import these cards into its own Kanban and keep ADLC artifact IDs on every card.

## Board Columns

planned, build, review, fix, test, commit, done, blocked

Codex manages board setup and task assignment for ADLC handoffs. Hermes owns
task execution and board progression after import.

## Card Contract

Each Hermes card must preserve:

- ADLC workstream id
- ADLC step id
- executor lane
- dependencies
- evidence links
- bounded write scope
- build instructions
- review gate
- fix gate
- test gate
- commit checkpoint
- blocker notes

## Lifecycle

1. Build the bounded step.
2. Review the diff against the step card and ADLC rules.
3. Fix review findings, then route back to an autonomous review/verify gate.
4. Test with the listed verification commands or mark missing tests as blockers.
5. Commit only the completed step slice.
6. Update the ADLC step card or return a precise status report for Codex to update it.

## Autonomous Gate Loop

Hermes should not ask the operator to review ordinary code, docs, tests, rules, or security fixes. A `review-required` or `fix-required` handoff means start the next ADLC gate or fixer unless the card names a human-gated blocker.

Use human-blocked only for explicit human decisions, credentials or external accounts, destructive or production operations, legal/security sign-off, scope or product ambiguity, or user-requested approval. If the board only has coarse statuses, create a linked review/fix card for the autonomous gate rather than marking the work human-blocked.

## Worker Profile

Use a Hermes profile configured for Codex GPT-5.5 with xhigh reasoning unless
the target project explicitly overrides the worker profile.

Ask before using an isolated worktree unless the target project config or user
request already requires one.
