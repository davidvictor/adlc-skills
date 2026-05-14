---
name: adlc-triage
description: Classify incoming work into ADLC categories and readiness states. Use when reviewing issues, feature requests, bug reports, backlog items, or preparing agent-ready briefs.
---

# ADLC Triage

Move incoming work to a clear next state.

## Model

Use one category and one readiness state.

Categories:

- `bug`
- `enhancement`
- `chore`
- `research`
- `design`
- `debt`

States:

- `needs-shaping`
- `needs-info`
- `ready-for-agent`
- `ready-for-human`
- `blocked`
- `deferred`
- `wontfix`

## Process

1. Read the request, comments, linked docs, and current labels or state.
2. Inspect repo context when the answer is discoverable from files or code.
3. Check `docs/adlc/operating-contract.md` for tracker and label mapping.
4. Check out-of-scope records before re-litigating rejected enhancements.
5. Recommend category and state with evidence.
6. If the work can become `ready-for-agent`, write a brief using [AGENT-BRIEF.md](./AGENT-BRIEF.md).
7. If rejected as `wontfix`, record durable scope memory only for real strategic rejections.

Ask only for missing decisions that block classification or agent readiness.

## Ready For Agent Gate

`ready-for-agent` requires a full AFK contract:

- current behavior
- desired behavior
- scope and non-goals
- key interfaces or contracts
- edge cases or blocked states
- acceptance criteria
- expected verification evidence
- dependencies and links
- no unresolved human judgment

## Closeout

Return:

- category
- state
- readiness gap, if any
- brief path or tracker link, if created
- durable rejection record, if created
