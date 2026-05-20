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
3. Fix review findings or mark blocked when the fix would exceed scope.
4. Test with the listed verification commands or mark missing tests as blockers.
5. Commit only the completed step slice.
6. Update the ADLC step card or return a precise status report for Codex to update it.

## Worker Profile

Use a Hermes profile configured for Codex GPT-5.5 with xhigh reasoning unless
the target project explicitly overrides the worker profile.

Ask before using an isolated worktree unless the target project config or user
request already requires one.
