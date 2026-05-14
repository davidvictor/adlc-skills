# Example Operating Contract

# ADLC Operating Contract

## Work Tracking

Default: hybrid local plus GitHub.

Local surfaces:

- PRDs: `docs/adlc/prds/`
- issue drafts: `.scratch/adlc-issues/`
- triage notes: `.scratch/adlc-triage/`
- handoffs: `.scratch/adlc-handoffs/`
- out-of-scope records: `.out-of-scope/`

External adapters:

- Tracker: GitHub Issues
- Publish command: `gh issue create --title <title> --body-file <file>`
- Label/status mapping: `docs/adlc/tracker-labels.md`

## Domain Docs

Layout: single-context.

- Context docs: `CONTEXT.md`
- ADR docs: `docs/adr/`
- Rules: update `CONTEXT.md` for durable domain language; use ADRs only for hard-to-reverse trade-offs.

## Verification

Default commands:

- lint/typecheck: `pnpm lint && pnpm typecheck`
- tests: `pnpm test`
- build: `pnpm build`
- browser/visual: `pnpm playwright test approval-flow.spec.ts`
- data/release smoke: `pnpm smoke:approval`

When verification is blocked, name the missing condition and the behavior still unverified.

## Release

`adlc-release` is required for user-facing workflow changes, migrations, scheduled jobs, and external integrations.
