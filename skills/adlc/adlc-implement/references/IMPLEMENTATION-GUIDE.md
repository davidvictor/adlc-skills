# ADLC Implementation Guide

Implementation is plan-driven.

## Order

1. Resolve `.adlc/config.yaml` with `adlc resolve-config` when available.
2. Read the active plan, rules, architecture, and relevant references.
3. For a workstream step, read the workstream overview, active Codex goal, milestone card, Kanban state, and step card.
4. Select one task or a set of independent tasks with disjoint write scopes.
5. Keep tightly coupled edits local to the coordinator.
6. Use workers only for bounded, parallel-safe tasks.
7. Run verification before moving a task to done.
8. Update task, step, milestone, and Kanban status as applicable, then record evidence.

## Worker Contract

Every worker assignment must include:

- task ID and goal
- milestone or workstream step ID when relevant
- write scope
- files or modules not to touch
- verification command or evidence expectation
- reminder that other agents may be editing nearby files

## Granularity Rules

- A task should be small enough to verify and review in one pass.
- A workstream step should produce one coherent commit or an explicitly grouped commit set.
- A milestone should carry multiple steps toward a releasable or operationally meaningful outcome.
- Split the work when a slice crosses unrelated ownership boundaries, requires separate release gates, or would obscure rollback.

## Done Means

- acceptance criteria are satisfied
- relevant tests or checks have run
- sidecar findings are resolved or recorded as residual risk
- plan status reflects the actual implementation state
- workstream and Codex goal status reflect the real remaining work when applicable
