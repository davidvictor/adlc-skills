# Hermes Sprint Smoke Example

This is a non-mutating ADLC sprint package for checking that Hermes can seed and manage an ADLC sprint without touching product code.

Use it when validating a local Hermes + ADLC setup after profile, skill, notification, or runner changes.

## Purpose

- Confirm Hermes can read an ADLC sprint package.
- Confirm the sprint is routed to the real `sprintrunner` profile or another discovered orchestrator profile.
- Confirm the task uses `adlc-hermes` and `kanban-orchestrator`, not the retired private `sprint-runner` skill.
- Confirm Telegram or other home-channel notifications are wired when enabled.

## Start Command

Run from the ADLC skills checkout:

```bash
scripts/seed-adlc-hermes-sprint.sh \
  --target-folder docs/examples/hermes-sprint-smoke \
  --assignee sprintrunner \
  --instructions "Run this non-mutating ADLC Hermes smoke sprint. Verify package discovery, profile routing, task skills, and notification setup. Do not edit product code."
```

Use `--no-telegram` when notification is intentionally disabled. Use `--telegram-chat-id <id>` when the Hermes home chat is not configured.

## Expected Result

Hermes creates or reuses a Kanban graph whose first task points back to this package, loads `adlc-hermes`, and completes with setup evidence. No source repo should be edited.
