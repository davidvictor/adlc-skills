# Example Diagnosis Report

# Diagnosis: High-Risk Approval Accepts Whitespace Notes

## Symptom

The UI disables submit for an empty high-risk note, but `"     "` can still be submitted through the API.

## Feedback Loop

`pnpm test approval-command -- --runInBand`

## Reproduction

Added a failing command test that submits a high-risk approval with a whitespace-only note. The command returned success and wrote an audit event.

## Hypotheses

| Rank | Hypothesis | Prediction | Result |
| --- | --- | --- | --- |
| 1 | UI trims but command does not | API path accepts whitespace while UI blocks it | Confirmed |
| 2 | Risk is not loaded in command path | All high-risk note checks are skipped | Rejected; empty note failed |
| 3 | Audit writer defaults missing notes | Approval fails but audit event masks it | Rejected; approval returned success |

## Cause

The approval command checked `note.length` before normalization. The UI normalized first, so UI and API behavior diverged.

## Fix

Normalize note text at the command boundary and pass normalized text to policy and audit writer.

## Regression Proof

`pnpm test approval-command` now covers empty, whitespace-only, too-short, and valid notes.

## Cleanup

No temporary instrumentation retained.

## Follow-Up

None. The command boundary is a sufficient seam for this bug.
