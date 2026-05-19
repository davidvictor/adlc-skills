---
name: adlc-commit
description: Prepare conventional commits from verified staged work and ADLC commit plans.
---

# ADLC Commit

Use this when implementation and gates are complete enough to commit.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read git status, diff, active plan, and commit plan.
3. Run `commit-preparer` when native Codex agents are available.
4. Stage by planned commit group. Use hunk staging or stop if one file spans unrelated groups.
5. Use conventional commit subjects.
6. Do not stage unrelated user work.

## Output

Report staged files, commit message, gate warnings, and whether a commit was created.
