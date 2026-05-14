---
name: adlc-build
description: Implement a vertical slice with a strong feedback loop. Use when building from an ADLC issue, PRD, plan, or agent brief after scope is ready for execution.
---

# ADLC Build

Build one vertical slice with evidence.

## Before Coding

Read the source artifact: agent brief, issue draft, PRD, plan, or prompt. Then inspect:

- repo guidance and ADLC operating contract
- relevant `CONTEXT.md` and ADRs
- current code, public interfaces, tests, and scripts
- release requirements if the change has production risk

If the artifact is not `ready-for-agent`, switch to `adlc-triage`, `adlc-probe`, or `adlc-shape` rather than guessing.

## Feedback Loop

Establish the strongest practical loop before substantial implementation. Use [FEEDBACK-LOOPS.md](./FEEDBACK-LOOPS.md).

TDD is preferred for:

- logic
- bug fixes with a correct seam
- stable public interfaces
- parsers, state machines, data transforms, and policy rules

Use [TDD-LOOP.md](./TDD-LOOP.md) when test-first development fits.

Alternate evidence is acceptable for:

- UI layout and motion
- docs
- config
- one-off migrations
- integration work where a safe local test seam does not exist

Use [UI-EVIDENCE.md](./UI-EVIDENCE.md) when visual or browser proof is the stronger evidence.

## Build Rules

- Work in thin vertical slices.
- Prefer behavior through public interfaces over implementation details.
- Keep local changes scoped to the artifact.
- Update docs or ADRs if the contract changes.
- Do not hide skipped checks behind "looks good".
- If you discover a bug before implementing, switch to `adlc-diagnose`.

## Closeout

Report:

- artifact implemented
- files changed at a high level
- feedback loop used before or during build
- verification run
- remaining risks, blockers, or not-verified behavior
- whether `adlc-audit`, `adlc-prove`, or `adlc-release` should run next
