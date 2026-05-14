# Operating Contract Template

```markdown
# ADLC Operating Contract

## Work Tracking

Default: local Markdown / configured tracker / hybrid.

Local surfaces:

- PRDs:
- issue drafts:
- triage notes:
- handoffs:
- out-of-scope records:

External adapters:

- Tracker:
- Publish command or workflow:
- Label/status mapping:

## Domain Docs

Layout: single-context / multi-context.

- Context docs:
- ADR docs:
- Rules for updating:

## Verification

Default commands:

- lint/typecheck:
- tests:
- build:
- browser/visual:
- data/release smoke:

When verification is blocked:

- state the blocker
- name the unverified behavior
- propose the smallest next check

## Release

Release skill required when changes affect:

- production deployment
- migrations or backfills
- external integrations
- scheduled jobs
- user-facing behavior
- operational runbooks or monitoring

## Handoffs

Use `.scratch/adlc-handoffs/<slug>.md` for durable task handoffs unless the repo config says otherwise.
```
