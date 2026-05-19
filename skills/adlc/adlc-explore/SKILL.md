---
name: adlc-explore
description: Explore options and constraints before planning without implementing code.
---

# ADLC Explore

Use this when scope, architecture, product direction, or tradeoffs are still unclear.

## Process

1. Read `.adlc/config.yaml`, description, architecture, rules, and active plans when present.
2. Inspect the live repo instead of asking for facts that can be discovered.
3. Compare viable options, risks, constraints, dependencies, and open decisions.
4. Ask only questions that materially change the plan, risk, or definition of done.
5. Persist findings to `.adlc/RESEARCH.md` only when requested or when the next plan depends on them.

## Output

Return the best direction, rejected alternatives, unresolved material questions, and whether the work is ready for `adlc-plan`.
