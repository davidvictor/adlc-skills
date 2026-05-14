---
name: adlc-slice
description: Break a PRD, plan, or spec into vertical-slice Markdown issue drafts. Use when the user wants issues, implementation tickets, sprint slices, or agent-ready work items from a plan.
---

# ADLC Slice

Break a plan into independently useful vertical slices.

Default to the repo's ADLC operating contract. If none exists, write local Markdown issue drafts. Create GitHub, Linear, Jira, or other tracker issues only when configured by `adlc-setup` or explicitly requested.

## Process

1. Read the PRD, plan, or spec.
2. Read `docs/adlc/operating-contract.md`, if present.
3. Explore the repo if needed to understand current shape.
4. Use `CONTEXT.md` vocabulary when present.
5. Draft thin vertical slices that cut through the necessary layers end to end.
5. Mark each slice as:
   - **AFK**: an agent can implement from the issue with no human decisions.
   - **HITL**: needs a human decision, design review, credential, or judgment call.
6. Present the proposed breakdown for approval before writing or publishing issues.
7. After approval, write drafts using [ISSUE-TEMPLATE.md](./ISSUE-TEMPLATE.md).
8. Publish to a tracker only when the contract or user request says to do so.

## Vertical Slice Rules

- Each slice should produce a demoable or verifiable result.
- Prefer many thin slices over a few broad ones.
- Avoid horizontal slices like "add database," "add API," then "add UI" unless each is independently valuable.
- Name dependencies explicitly.
- Include blocked states instead of pretending uncertainty is resolved.
- For AFK slices, satisfy the `ready-for-agent` gate from `adlc-triage`.

## Markdown Draft Location

If the user does not specify a location, write drafts under:

```text
.scratch/adlc-issues/<slug>/
```

Do not publish to external trackers without explicit instruction.

## Closeout

Report issue draft paths, tracker links if published, AFK/HITL split, dependencies, and any slices that still need shaping.
