# ADLC Implementation Guide

Implementation is plan-driven.

## Order

1. Resolve `.adlc/config.yaml` with `adlc resolve-config` when available.
2. Read the active plan, rules, architecture, and relevant references.
3. Select one task or a set of independent tasks with disjoint write scopes.
4. Keep tightly coupled edits local to the coordinator.
5. Use workers only for bounded, parallel-safe tasks.
6. Run verification before moving a task to done.
7. Update task status and record evidence.

## Worker Contract

Every worker assignment must include:

- task ID and goal
- write scope
- files or modules not to touch
- verification command or evidence expectation
- reminder that other agents may be editing nearby files

## Done Means

- acceptance criteria are satisfied
- relevant tests or checks have run
- sidecar findings are resolved or recorded as residual risk
- plan status reflects the actual implementation state
