---
name: adlc-release
description: Plan and verify rollout, rollback, and operational evidence. Use when changes affect production, migrations, data backfills, scheduled jobs, external integrations, monitoring, or user-facing risk.
---

# ADLC Release

Do not confuse "merged" with "released safely".

## Trigger

Run this skill when the change touches:

- production deployment
- migrations or backfills
- external APIs or credentials
- scheduled jobs or queues
- user-facing behavior
- billing, auth, data integrity, or safety
- monitoring, runbooks, or alerts

## Inspect

Read:

- ADLC operating contract
- PRD, issue, or closeout
- deployment config and CI
- migration/backfill scripts
- env and secret expectations
- observability surfaces
- rollback path

## Release Plan

Use [RELEASE-CHECKLIST.md](./RELEASE-CHECKLIST.md). Keep the plan proportional to risk.

## Verification

Name evidence for:

- pre-release checks
- release command or owner
- smoke test
- monitoring or logs to watch
- rollback command or recovery path
- post-release acceptance

If a release step is outside agent access, mark it as human-owned with exact instructions.

## Closeout

Report:

- release readiness verdict
- blockers
- human-owned actions
- rollback plan
- monitoring plan
- what remains not verified
