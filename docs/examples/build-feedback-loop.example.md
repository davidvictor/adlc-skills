# Example Build Feedback Loop

# Build Feedback Loop: Approval Notes

## Source Artifact

`.scratch/adlc-issues/approval-notes/01-require-note-policy.md`

## Loop Chosen

Behavior test through the approval policy module plus browser flow for the approval dialog.

## Why This Loop

The policy module is the correct seam for risk/note validation. The dialog still needs browser proof because disabled submit state, inline error text, and focus behavior are visual/interaction concerns.

## Red

- Add test: high-risk request without note returns `missing_required_note`.
- Add test: whitespace-only note returns `missing_required_note`.

## Green

- Trim note before validation.
- Require 12 visible characters only for high-risk requests.

## Refactor

- Move note normalization into the approval command path so API and UI use the same rule.

## Verification

- `pnpm test approval-policy`
- `pnpm test approval-command`
- `pnpm playwright test approval-dialog.spec.ts`

## Remaining Risk

Audit trail persistence is covered by command tests, not by the browser flow.
