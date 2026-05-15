# Verify Hermes Managed ADLC Sprint Creation

This is a non-mutating smoke item for Hermes setup verification.

## Scope

- Confirm Hermes can create or reuse a managed ADLC Kanban task from this target folder.
- Confirm the task is routed to a real orchestrator profile.
- Confirm the task carries `adlc-hermes` and `kanban-orchestrator`.
- Confirm notification setup is visible when the seeder subscribes a Telegram chat.

## Out Of Scope

- Product code edits.
- Repository commits.
- External pull requests.
- Production or credentialed actions.

## Acceptance

- The task appears on the configured Kanban board.
- `hermes kanban show <task_id>` includes this target folder, assignee, workspace, and requested skills.
- The task completes with a concise setup verdict and any notification caveats.

## Verification

- `hermes kanban --board <board> list`
- `hermes kanban --board <board> show <task_id>`
- Optional: confirm a Telegram lifecycle notification landed if notifications were enabled.
