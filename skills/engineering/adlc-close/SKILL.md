---
name: adlc-close
description: Convert audit or review findings into fixes, explicit deferrals, blockers, or accepted residual risks with fresh verification evidence. Use when the user wants to close review findings, address audit feedback, or prove a review is actually resolved.
---

# ADLC Close

Close findings by doing the work, not by summarizing the review again.

## Process

1. Read the review, audit, or comment thread.
2. Create a finding ledger.
3. Classify every finding:
   - fix
   - defer
   - block
   - accept residual risk
4. Apply the smallest safe fixes.
5. Update PRD, issue, ADR, or `CONTEXT.md` if the contract changed.
6. Rerun the relevant verification after fixes.
7. Record what is verified, partial, blocked, or not verified.
8. Use `adlc-release` when fixed findings affect production risk.

## Fix Plan Gate

Before editing, write a short fix plan:

- finding id
- action: fix, defer, block, or accept residual risk
- files or surfaces expected to change
- verification to rerun
- scope verdict: in-scope or needs human planning decision

Proceed autonomously when every fix is inside the approved artifact scope. Block only when the plan requires new product scope, destructive action, missing credentials, or a human decision.

## Ledger Shape

```markdown
| Finding | Action | Evidence | Final State |
| --- | --- | --- | --- |
| <finding> | fix/defer/block/risk | <command, diff, doc path, or reason> | closed/open |
```

## Rules

- Do not re-review for sport.
- Do not claim closure without fresh verification.
- Do not hide blockers in vague risk language.
- Do not revert unrelated user work.
- If a finding is deferred, state who owns the decision and why it is safe to defer.
- If a finding becomes new scope, create or update an issue instead of burying it.

## Runner Handoff

When running inside Hermes Kanban or another durable task runner:

- Read the audit ledger first, then the surrounding prose.
- Post the fix plan as a durable comment or closeout section before code changes.
- Complete with `findings_resolved`, `verification`, `commit_hashes` when a commit is requested, `residual_risk`, and `next_adlc_phase`.
- Block with a precise reason only for true human/environment/scope blockers.

## Closeout

End with:

- fixed findings
- deferred or accepted risks
- blockers
- verification run after fixes
- anything still not verified
- next skill if release, proof, or handoff is needed
