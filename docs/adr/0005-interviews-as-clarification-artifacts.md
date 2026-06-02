---
id: adlc-adr-0005-interviews
type: adr
status: accepted
owner: ADLC
---

# ADR 0005: Interviews Clarify Ambiguous Work

Status: accepted

## Context

Large software work often fails in planning because product intent, non-goals, authority boundaries, and acceptance criteria are still implicit. ADLC needs a durable clarification surface that turns those decisions into artifacts before task graphs and workstreams are created.

## Decision

ADLC adds `adlc-interview` as the public clarification skill.

Interview artifacts live under `paths.interviews`, default `.adlc/interviews/`. Each interview writes a context snapshot, transcript, and source-of-truth spec.

Every user-facing question uses one-question rounds with:

- definitions for relevant terms
- lettered options
- a recommendation naming one option or a blend

The interview scores ambiguity, requires explicit non-goals and decision boundaries, performs a pressure pass, separates evidence from inference, and hands downstream skills a spec path.

## Consequences

Planning, workstream, architecture, and roadmap skills can consume a clarified source-of-truth spec instead of encoding open ambiguity as tasks. The config template and project scaffold include an interview root so target projects have a standard place for clarification artifacts.
