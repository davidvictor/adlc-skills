---
name: adlc-handoff
description: Create durable ADLC handoffs for another agent or future session. Use when pausing work, transferring a branch, surviving context compaction, or preparing follow-up execution.
---

# ADLC Handoff

Preserve the next useful step without duplicating existing artifacts.

## Destination

Use `.scratch/adlc-handoffs/<slug>.md` for repo-attached work. Use a temp file only for ephemeral conversation transfer.

## Process

1. Inspect current branch, diff, recent commits, and untracked files.
2. Read source artifacts: PRD, issue, brief, ADR, audit, or plan.
3. Summarize only what is not already captured elsewhere.
4. Name blockers, risks, not-verified behavior, and exact next checks.
5. Recommend the next ADLC skill.

## Write

Use [HANDOFF-FORMAT.md](./HANDOFF-FORMAT.md).

Do not hide uncertainty. Do not copy large diffs, PRDs, or issue bodies; link paths instead.

## Closeout

Return the handoff path and the next recommended action.
