# Release Checklist

```markdown
# Release Plan: <Change>

## Scope

What is being released and what is not.

## Risk

Low / medium / high, with reason.

## Preconditions

- [ ] CI/local verification:
- [ ] Migration/backfill dry run:
- [ ] Env/secrets:
- [ ] Feature flag/config:
- [ ] Stakeholder or operator notice:

## Rollout

Steps, commands, owners, and expected duration.

## Smoke Test

The smallest behavior that proves the release is alive.

## Monitoring

Dashboards, logs, alerts, metrics, or queries to watch.

## Rollback

Exact rollback or recovery path. Include data rollback limits if relevant.

## Post-Release Evidence

What must be captured before the work is considered released.
```
