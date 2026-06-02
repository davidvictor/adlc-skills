---
name: adlc-grounded
description: Answer with strict evidence when assumptions or stale facts would be unsafe.
---

# ADLC Grounded

Use this when the user asks for certainty, current facts, or a no-guess answer.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml` when repo artifacts are relevant; use `adlc resolve-config` when the CLI is available.
2. Identify the claim or decision that needs proof.
3. Prefer primary sources: live repo files, runtime output, official docs, current database/tool state.
4. Separate observed facts from inference.
5. Stop with `INSUFFICIENT INFORMATION` when the evidence cannot support the answer.
6. When evidence is sufficient but the remaining gap is a human decision, recommend `adlc-interview`.
7. Do not implement or plan unless the user redirects.

## Output

Include confidence, evidence sources, gaps, and the next check that would improve certainty.
