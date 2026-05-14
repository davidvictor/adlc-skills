# Example Lifecycle Thread: OpsDesk Approval Notes

Scenario: OpsDesk is a lightweight SaaS operations app. Managers review intake requests and approve, reject, or ask for more information. Operators need a short required approval note on high-risk requests.

## 1. Setup

`adlc-setup` records:

- work tracking: hybrid local + GitHub
- domain docs: single `CONTEXT.md`
- verification: `pnpm test`, `pnpm lint`, Playwright for approval flow UI
- release: required for user-facing workflow changes

## 2. Probe

Resolved decision:

- approval notes are required only when request risk is `high`
- note minimum is 12 visible characters after trimming
- saved note appears in the audit trail
- rollback is a feature flag: `approval_notes_required`

Deferred:

- note templates for regulated teams

## 3. Shape

PRD outcome:

- high-risk approvals cannot complete without a note
- existing low/medium approvals stay unchanged
- audit trail records actor, timestamp, request id, and note text
- verification includes behavior tests plus browser flow

## 4. Slice

Slices:

1. Add note requirement to approval policy module (`AFK`)
2. Persist approval notes in audit trail (`AFK`)
3. Update approval dialog and validation states (`HITL` for design review)
4. Release behind `approval_notes_required` (`AFK` after flag exists)

## 5. Build

Feedback loop:

- failing approval-policy test for high-risk request without note
- passing policy tests for low/medium requests
- Playwright approval dialog check for disabled submit state

## 6. Audit And Close

Finding:

- approval dialog accepted whitespace-only notes.

Closeout:

- trim validation fixed
- regression test added
- Playwright screenshot captured for error state

## 7. Prove

Claim: "approval notes are verified."

Verdict: strong for policy and UI submit state; partial for audit trail because the Playwright flow did not inspect the persisted audit entry.

Next check: add or run an audit-trail retrieval assertion.

## 8. Release

Release plan:

- ship with flag off
- deploy migration
- enable flag for internal team
- smoke high-risk approval path
- watch approval error logs and audit write failures
- rollback by disabling flag

## 9. Handoff

Handoff records:

- branch
- feature flag status
- tests run
- audit-trail proof still needed
- next skill: `adlc-prove`
