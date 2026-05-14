# Migrations, Backfills, And Flags

## Migrations

Before release, name:

- forward migration command
- backward compatibility expectation
- whether old code can run against new schema
- rollback limits
- data validation query

If rollback cannot undo data changes, say so.

## Backfills

Name:

- dry-run command
- batch size or throttle
- resume behavior
- failure handling
- verification query
- owner watching the run

## Feature Flags

Name:

- flag key
- default state
- first audience
- expansion plan
- rollback action
- stale-flag cleanup owner

Flags are not a substitute for verification. They are a rollout control.
