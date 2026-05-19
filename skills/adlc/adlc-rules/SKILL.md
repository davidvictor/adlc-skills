---
name: adlc-rules
description: Capture ADLC project rules, area conventions, and durable operating constraints.
---

# ADLC Rules

Use this when project conventions need to become durable before planning, implementation, or review.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read configured base rules and area-rule files.
3. Decide whether the rule belongs in the base rules file or an area-specific file.
4. Keep rules short, testable, and operational.
5. Remove duplicates and stale rules when replacing them.
6. Do not implement feature code from this skill.

## Output

Report updated rule files, new or removed rules, affected workflow stages, and whether `adlc-rules-check` should run.
