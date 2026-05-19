---
name: adlc-improve
description: Refine an existing ADLC plan for completeness, order, and execution readiness.
---

# ADLC Improve

Use this after `adlc-plan` when the plan needs a second pass before execution.

## Process

1. Locate the target plan from an explicit path, current branch, `.adlc/plans/`, `.adlc/PLAN.md`, or `.adlc/fixes/`.
2. Check missing tasks, unclear dependencies, risky batch size, missing verification, missing docs/env gates, and duplicated work.
3. Remove redundant tasks and split broad ones.
4. Preserve the plan's goal; do not expand scope without naming the expansion.
5. Show a concise change summary before or with the updated plan.

## Output

Return updated plan path, material changes, remaining risks, and readiness for `adlc-implement`.
