---
name: adlc-grounded
description: Answer with strict evidence when assumptions or stale facts would be unsafe.
---

# ADLC Grounded

Use this when the user asks for certainty, current facts, or a no-guess answer.

## Process

1. Identify the claim or decision that needs proof.
2. Prefer primary sources: live repo files, runtime output, official docs, current database/tool state.
3. Separate observed facts from inference.
4. Stop with `INSUFFICIENT INFORMATION` when the evidence cannot support the answer.
5. Do not implement or plan unless the user redirects.

## Output

Include confidence, evidence sources, gaps, and the next check that would improve certainty.
