# Example Agent Brief

# Agent Brief: Require Notes For High-Risk Approval

## Category

enhancement

## Summary

High-risk requests cannot be approved unless the approver enters a meaningful note.

## Current Behavior

Approvers can approve any request without a note. The audit trail records the approval action but does not capture why a high-risk request was approved.

## Desired Behavior

When request risk is `high`, the approval flow requires a note with at least 12 visible characters after trimming. Low and medium risk approvals keep the current optional-note behavior. The audit trail stores the note with the approval event.

## Scope

- Included: approval policy, approval dialog validation, audit trail write shape.
- Key interfaces: approval policy decision, approval submission command, audit event payload.
- Constraints: preserve existing low/medium approval behavior.

## Non-Goals

- Note templates.
- Changing risk scoring.
- Backfilling notes for historical approvals.

## Edge Cases And Blocked States

- Whitespace-only notes are invalid.
- High-risk approvals from API clients must receive the same validation error as UI clients.
- If audit write fails, approval should fail rather than silently approve without a note.

## Acceptance Criteria

- [ ] High-risk approval without a note is rejected.
- [ ] High-risk approval with a trimmed 12+ character note succeeds.
- [ ] Low and medium risk approvals still work without notes.
- [ ] Approval audit events include the note for high-risk requests.
- [ ] UI submit state and error message are verified.

## Verification

Run policy tests, API submission tests, and browser approval flow checks. Capture the UI error state if visual validation changed.

## Dependencies

- PRD: `docs/adlc/prds/approval-notes.md`
- Feature flag: `approval_notes_required`
