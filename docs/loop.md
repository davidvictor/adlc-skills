---
id: adlc-doc-loop
type: guide
status: active
owner: ADLC
---

# Loop

`adlc-loop` runs bounded iterative improvement when one implementation pass is unlikely to be enough.

## Inputs

- loop goal
- acceptance criteria
- maximum iterations
- stop conditions
- active plan or fix plan
- prior verification, review, QA, and patch notes

## Iteration Shape

1. Select the smallest useful next change.
2. Implement through `adlc-implement` or `adlc-fix`.
3. Run `adlc-verify` and relevant gates.
4. Record loop notes under configured `paths.loops`.
5. Continue only while criteria and risk justify another pass.

## Stop Conditions

Stop when criteria pass, risk rises, iteration budget is exhausted, a blocker requires user decision, or a gate fails in a way that needs replanning.

