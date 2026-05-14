# Hybrid Local Contract With Optional Tracker Adapters

Status: Accepted

## Context

ADLC skills should work across many repositories and agents. Some repos have GitHub, Linear, Jira, or other trackers. Others are local, private, experimental, or not yet attached to a team workflow.

If ADLC writes only to external trackers, it becomes brittle and tool-specific. If it writes only local Markdown, it becomes less useful for team workflows.

## Decision

ADLC uses a hybrid model:

- local repo artifacts are the durable default contract
- external trackers are optional adapters configured by `adlc-setup` or explicitly requested by the user
- PRDs, issue drafts, handoffs, triage notes, and out-of-scope records must remain representable as local files

Default local surfaces are:

- `docs/adlc/` for operating-contract docs
- `.scratch/adlc-issues/` for local issue drafts
- `.scratch/adlc-handoffs/` for task handoffs
- `.out-of-scope/` or the configured ADLC equivalent for durable rejected-scope memory

## Consequences

ADLC stays portable and agent-friendly while still supporting serious team trackers. Skills must describe the local artifact shape first, then mention tracker publishing as an adapter step.
