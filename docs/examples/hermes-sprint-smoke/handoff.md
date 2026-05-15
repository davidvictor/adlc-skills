# Hermes ADLC Smoke Handoff

Sprint package: `docs/examples/hermes-sprint-smoke`
Board: `adlc-smoke`
Workspace: `scratch`
Orchestrator: discovered profile, normally `sprintrunner`
Notification: telegram if configured, otherwise none

## Expected Graph

- item 01 smoke verification completes with profile, skill, board, workspace, and notification evidence

## Human Decisions

- none

## Blocked State Rules

Use blocked state only if Hermes cannot access required local setup:

- `environment-blocker:` Hermes command unavailable or gateway not running
- `environment-blocker:` required ADLC or Kanban skills are not installed
- `environment-blocker:` requested orchestrator profile does not exist
- `credential-blocker:` selected provider is not authenticated enough to run

Do not block for ordinary review handoff. This smoke sprint does not perform product work.

## Watch

```bash
hermes kanban --board adlc-smoke list
hermes kanban --board adlc-smoke watch
```
