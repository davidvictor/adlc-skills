---
name: adlc-improve
description: Refine an existing ADLC plan for completeness, order, and execution readiness.
---

# ADLC Improve

Use this after `adlc-plan` when the plan needs a second pass before execution.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Locate the target plan from an explicit path, current branch, configured plans path, configured fast-plan path, or configured fixes path.
3. Check missing tasks, unclear dependencies, risky batch size, missing milestones, missing verification, missing docs/env gates, missing rollback notes, and duplicated work.
4. Remove redundant tasks and split broad ones into reviewable, commit-capable slices.
5. Promote the plan to `adlc-workstream` when it needs Codex goal continuity, multiple milestones, or durable multi-sprint state.
6. Preserve the plan's goal; do not expand scope without naming the expansion.
7. Show a concise change summary before or with the updated plan.

## Output

Return updated plan path, material changes, remaining risks, and readiness for `adlc-implement`.
