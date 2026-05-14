# Example Release Plan

# Release Plan: Approval Notes

## Scope

Release the high-risk approval note requirement behind `approval_notes_required`.

## Risk

Medium. The change blocks a user action and writes new audit payload data.

## Preconditions

- [ ] `pnpm test approval-command`
- [ ] `pnpm playwright test approval-dialog.spec.ts`
- [ ] migration applied in staging
- [ ] flag exists in staging and production
- [ ] support team notified of the new validation message

## Rollout

1. Deploy code with flag off.
2. Run smoke check with low-risk approval.
3. Enable flag for internal workspace.
4. Run high-risk approval smoke.
5. Enable flag for 10 percent of workspaces.
6. Expand after 24 hours without audit write errors.

## Smoke Test

Approve one high-risk request with a valid note and confirm audit trail contains the note.

## Monitoring

- approval submission errors by reason
- audit write failures
- support tickets mentioning approval notes

## Rollback

Disable `approval_notes_required`. The schema remains compatible and does not need rollback.

## Post-Release Evidence

Screenshot or log link showing successful high-risk approval with audit note after flag enablement.
