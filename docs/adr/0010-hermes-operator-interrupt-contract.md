# Hermes Operator Interrupt Contract

Status: Accepted

## Context

Early Hermes sprint research proved that long-running work needs a durable human interrupt path. Chat clarification prompts are useful for live sessions, but they time out, disappear from the Kanban task record, and do not survive restarts as well as task comments and blocked state.

ADLC Hermes runs now use Hermes Kanban as the execution state machine. The operator still owns planning authority, scope decisions, credentials, destructive approvals, and production release choices.

## Decision

Human intervention during Hermes-managed ADLC work must be represented in Kanban.

- Workers add context as Kanban comments.
- Workers use `blocked` only when a human decision or missing condition is required.
- The blocked reason should be one short, actionable sentence with a stable prefix such as `human-decision:`, `credential-blocker:`, `environment-blocker:`, `scope-expansion:`, or `unsafe-verification:`.
- The operator responds by commenting on the task and unblocking it, either with `/kanban comment` plus `/kanban unblock` or through a platform-specific helper that performs those same actions.
- Telegram or mobile notifications are an interrupt surface, not the source of truth. They should point back to the Kanban task id and tell the operator what can be changed.

## Consequences

ADLC agents can keep executing, retrying, reviewing, fixing, and proving work without surrendering human control over planning boundaries.

Operators can handle interruptions from a phone while the durable decision still lands in the task thread for later workers.

Future ADLC runner improvements should strengthen this Kanban comment/block/unblock loop rather than reintroducing transient clarification prompts as the primary sprint-control mechanism.
