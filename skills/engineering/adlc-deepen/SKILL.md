---
name: adlc-deepen
description: Find architecture improvements that increase module depth, locality, leverage, and testability. Use when the user wants architecture review, refactoring opportunities, better seams, cleaner interfaces, or a less tangled codebase.
---

# ADLC Deepen

Find opportunities to make the codebase easier to change and easier for agents to navigate.

Use the vocabulary in [LANGUAGE.md](./LANGUAGE.md).

## Explore

Read `CONTEXT.md` and relevant ADRs first when present. Then inspect the code organically.

Look for:

- modules that are shallow pass-throughs
- concepts spread across many call sites
- interfaces that expose too many implementation details
- tests that reach past public interfaces
- seams with only one real adapter
- behavior that is hard to verify from one place
- coupling that hides the real owner of a decision

Apply the deletion test: if deleting a module makes complexity vanish, it was probably shallow. If deleting it spreads complexity across callers, it was earning its keep.

## Present Candidates

Return a numbered list. For each candidate include:

- **Area**: the concept or module cluster
- **Friction**: why the current shape hurts understanding, change, or tests
- **Deepening move**: what changes
- **Leverage**: what callers gain
- **Locality**: where change and verification concentrate
- **Risk**: what could make the refactor unsafe

Do not implement. Ask which candidate the user wants to explore.

## If The User Picks One

Drop into a probe:

- clarify the intended interface
- classify dependencies using [DEEPENING.md](./DEEPENING.md)
- identify adapters and test stand-ins
- decide what old tests can be deleted or replaced
- decide whether a prototype or ADR is needed

Only write a plan or code if the user asks.
