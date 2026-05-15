# Hermes Phase Gate State Contract

Status: Accepted

## Context

Hermes Kanban promotes child tasks when the parent task completes. ADLC's runner graph depends on that behavior for build, hostile review, close, proof, release, and handoff phases.

Early ADLC Hermes runs used blocked state for normal quality gates such as "review required." That preserved intent for a human reader, but it stopped the dependency graph: review tasks remained todo because their build parents were blocked instead of done.

## Decision

Normal ADLC phase gates complete into the next phase.

- Build completes after implementation and self-verification, with `review_required=true` and `next_adlc_phase=adlc-audit`.
- Audit completes after review, with `approved=true` or `approved=false` plus a finding ledger.
- Close completes after every finding is fixed, deferred, blocked with evidence, or accepted as residual risk.
- Prove completes after each verification claim receives a verdict.

Blocked state is reserved for true stop conditions:

- human planning, product, or scope decisions
- missing credentials, browser sessions, accounts, or local environment
- destructive or production-risk approval
- scope expansion outside the approved work item
- verification that cannot reach a useful verdict

`review-required:` is not a valid blocked reason for new ADLC Hermes runs.

## Consequences

Hermes can autonomously move work from QA to review to fix to proof while preserving human planning authority.

Human control remains at the plan, scope, credential, destructive-action, and release-decision boundaries. Agents own execution, validation, review, fix planning, fixes, proof, and scoped commits after the plan is approved.

Runbooks and seed scripts must reinforce this contract so worker profiles do not accidentally deadlock the graph.
