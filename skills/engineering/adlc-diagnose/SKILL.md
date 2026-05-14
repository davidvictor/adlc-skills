---
name: adlc-diagnose
description: Diagnose bugs and regressions with a strict feedback-loop discipline. Use when something is broken, failing, flaky, slow, throwing, or behaving unexpectedly.
---

# ADLC Diagnose

Do not fix before you can see the failure.

## Phase 1: Build The Loop

Construct or find a pass/fail loop that reproduces the reported behavior:

- failing test
- CLI or HTTP script
- browser script
- fixture replay
- minimal harness
- stress loop for flakes
- human-in-the-loop script when unavoidable, guided by [HITL-LOOP.md](./HITL-LOOP.md)

If you cannot build a loop, stop and report what artifact or access is missing.

## Phase 2: Reproduce

Run the loop and confirm it matches the user's reported symptom. Capture exact errors, outputs, timing, screenshots, or logs.

## Phase 3: Hypothesize

Write 3 to 5 ranked, falsifiable hypotheses. Each must predict what evidence would confirm or disprove it.

## Phase 4: Instrument

Probe one hypothesis at a time. Prefer debuggers, targeted logs, trace output, or narrowed harnesses. Tag temporary logs with a unique marker and remove them before closeout.

## Phase 5: Fix And Lock

When a correct seam exists, convert the reproduction into a regression test before or alongside the fix. If no correct seam exists, say so and recommend follow-up architecture work.

## Phase 6: Cleanup

Before claiming done:

- original repro no longer reproduces
- regression proof runs or absence of seam is documented
- temporary instrumentation is removed
- throwaway harnesses are deleted or clearly marked
- the confirmed cause is recorded in the closeout

Use [CLEANUP.md](./CLEANUP.md) before closeout.

## Closeout

Use [DIAGNOSIS-REPORT.md](./DIAGNOSIS-REPORT.md).
