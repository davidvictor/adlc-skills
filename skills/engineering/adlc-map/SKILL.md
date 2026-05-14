---
name: adlc-map
description: Zoom out and explain how an unfamiliar area of code fits into the larger system. Use when the user asks for a map, broader context, module/caller relationships, or how a feature works end to end.
disable-model-invocation: true
---

# ADLC Map

Go up one level of abstraction.

Explore the relevant code and docs, then explain:

- the core concepts using `CONTEXT.md` vocabulary when available
- the main modules involved
- callers and call direction
- data or control flow
- important external dependencies
- key tests or verification surfaces
- surprising constraints or ADRs
- the smallest useful next step

Prefer a compact map over a file-by-file tour. Mention files only when they help the user navigate.
