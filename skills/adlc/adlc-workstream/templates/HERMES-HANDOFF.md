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

ready, build, review, test, commit, done, blocked

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
- test gate
- commit checkpoint
- blocker notes

## Lifecycle

1. Build the bounded step.
2. Review the diff against the step card and ADLC rules.
3. Test with the listed verification commands or mark missing tests as blockers.
4. Commit only the completed step slice.
5. Update the ADLC step card or return a precise status report for Codex to update it.
