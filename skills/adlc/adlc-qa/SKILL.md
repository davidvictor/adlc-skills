---
name: adlc-qa
description: Produce ADLC QA artifacts such as change summaries, test plans, and manual test cases.
---

# ADLC QA

Use this when a feature or fix needs explicit manual QA beyond automated checks.

## Modes

- `change-summary`: summarize the actual diff and user-visible behavior.
- `test-plan`: define coverage areas, environments, risks, and pass criteria.
- `test-cases`: write concrete manual test cases.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read the active plan, diff, verification output, review output, rules, and relevant docs.
3. Write QA artifacts under the configured QA path.
4. Keep QA tied to actual behavior and acceptance criteria.
5. Mark blocked or untestable cases explicitly.
6. Do not change implementation code from this skill.

## Output

Report QA artifact paths, coverage gaps, blocked cases, and whether the work is ready for `adlc-review` or `adlc-commit`.
