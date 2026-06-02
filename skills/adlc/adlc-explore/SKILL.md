---
name: adlc-explore
description: Explore options and constraints before planning without implementing code.
---

# ADLC Explore

Use this when scope, architecture, product direction, or tradeoffs are still unclear.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read description, architecture, rules, and active plans when present.
3. Inspect the live repo instead of asking for facts that can be discovered.
4. Compare viable options, risks, constraints, dependencies, and open decisions.
5. If user decisions remain after repo evidence is collected, hand off to `adlc-interview` for optioned one-question rounds instead of bundling many questions into exploration.
6. Ask directly only when one answer materially changes the plan, risk, or definition of done and does not need a full interview artifact.
7. Persist findings to the configured research path only when requested or when the next plan or interview depends on them.

## Output

Return the best direction, rejected alternatives, unresolved material questions, and whether the work is ready for `adlc-interview` or `adlc-plan`.
