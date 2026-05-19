---
name: adlc-loop
description: Run an iterative ADLC improvement loop with explicit criteria, gates, and stop conditions.
---

# ADLC Loop

Use this for bounded iterative improvement where one pass is unlikely to be enough.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Define the loop goal, criteria, maximum iterations, and stop conditions.
3. Read roadmap, rules, active plan, verification history, QA artifacts, and patches.
4. For each iteration, plan the smallest useful change, implement it through `adlc-implement` or `adlc-fix`, then run `adlc-verify` and relevant gates.
5. Record loop notes under the configured loops path.
6. Stop when criteria pass, risk rises, the iteration budget is exhausted, or a human decision is required.

## Output

Report iteration count, changes made, gates run, remaining gaps, stop reason, and the next command.
