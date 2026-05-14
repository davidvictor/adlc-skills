---
name: adlc-plan
description: Create an ADLC plan from fuzzy intent by routing through interview, repo grounding, PRD shaping, and vertical slicing without implementing.
---

# ADLC Plan

Create a plan that can actually be executed.

Use this as the explicit planning entrypoint when the user asks for a plan, roadmap, implementation plan, issue breakdown, or "how should we build this?" Do not implement from this skill unless the user separately asks to switch into execution.

## Process

1. Read `docs/adlc/operating-contract.md`, if present.
2. Read `CONTEXT.md`, `CONTEXT-MAP.md`, and relevant ADRs when the plan is repo-specific.
3. Capture a plan intake using [PLAN-WORKFLOW.md](./PLAN-WORKFLOW.md).
4. Route unresolved decisions to `adlc-probe`.
5. Route repo-language or architecture alignment to `adlc-anchor`.
6. Route discovery needs to `adlc-map`, `adlc-deepen`, or `adlc-spike` when needed before shaping.
7. Route resolved scope to `adlc-shape` for the PRD or implementation contract.
8. Route requested steps, tickets, or sprint work to `adlc-slice`.
9. Route execution-readiness classification to `adlc-triage`.

## Rules

- Treat planning as a ladder: decision clarity, shaped artifact, sliced work, ready execution.
- Ask only questions that would change scope, implementation, verification, release, or risk.
- Ask one question at a time and include a recommended answer when interviewing.
- Inspect discoverable repo facts instead of asking the user to restate them.
- Prefer local Markdown artifacts unless the operating contract or user request names a tracker.
- Keep external trackers optional; never publish issues unless configured or explicitly requested.
- Keep implementation out of scope until the plan artifacts are accepted or the user redirects.

## Output Contract

Depending on the user's ask and current certainty, produce one or more of:

- a planning decision log with open questions and assumptions
- a PRD or implementation contract, usually under `docs/adlc/prds/<slug>.md`
- vertical issue drafts, usually under `.scratch/adlc-issues/<slug>/`
- agent-ready briefs for AFK slices when `adlc-triage` is requested or needed

If the plan is not ready to shape, say why and continue the interview instead of producing a thin plan.

## Closeout

Report:

- which route was used
- what artifacts were created or intentionally withheld
- open questions, deferred decisions, and accepted risks
- next recommended skill: `adlc-shape`, `adlc-slice`, `adlc-triage`, `adlc-build`, `adlc-spike`, or `adlc-interface`
