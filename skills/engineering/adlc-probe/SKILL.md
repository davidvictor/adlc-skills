---
name: adlc-probe
description: Interrogate a plan or design one decision at a time until the design tree is resolved. Use when the user wants to stress-test an idea, clarify a plan, decide between options, or align before implementation.
---

# ADLC Probe

Probe the plan until the user and agent share the same mental model.

Use this for planning and direction. Do not treat it as permission to implement.

## Rules

- Ask one question at a time.
- Include your recommended answer with every question.
- Walk dependencies in order: resolve upstream decisions before downstream details.
- If the answer can be discovered by exploring the repo, inspect the repo instead of asking.
- Keep probing until the unresolved decisions are either answered, explicitly deferred, or marked as risks.
- Do not edit files unless the user asks you to turn the answers into an artifact.
- Maintain an assumption ledger as you go.
- Stop asking when the remaining uncertainty would not change implementation, verification, rollout, or risk.

## Question Shape

Use this format:

```markdown
Question: <one decision that materially affects the plan>

Why it matters: <one sentence>

Options:
A. <option>
B. <option>
C. <option>

Recommendation: <recommended option and why>
```

## Decision Tree

Prefer this order:

1. Outcome: what changes for the user or operator?
2. Scope: what is in, out, and intentionally deferred?
3. Users: who invokes, operates, or experiences this?
4. Current state: what does the repo already do?
5. Constraints: technical, product, safety, data, auth, cost, deadline.
6. Interfaces: APIs, modules, data contracts, commands, UI surfaces.
7. Edge cases: unsupported inputs, failure modes, blocked states.
8. Verification: what evidence would prove the work is done?
9. Rollout and rollback: how it ships and how to back out.
10. Documentation: what should be recorded after decisions crystallize?

## Assumption Ledger

Track:

- confirmed facts
- recommended defaults accepted by silence or explicit answer
- open decisions
- deferred decisions
- risks accepted

If an assumption becomes load-bearing, ask about it or mark it as a risk. Do not smuggle assumptions into implementation plans.

## Closeout

When the tree is resolved, summarize:

- decisions made
- decisions deferred
- risks accepted
- repo facts discovered
- recommended next skill: `adlc-anchor`, `adlc-shape`, `adlc-spike`, `adlc-interface`, `adlc-build`, or no action
