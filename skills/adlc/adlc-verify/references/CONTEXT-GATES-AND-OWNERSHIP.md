# Context Gates And Ownership

`adlc-verify` is read-only by default. It proves whether implementation matches the plan and rules.

## Required Context

- effective ADLC config paths
- active plan or fix plan
- architecture and rules relevant to the changed area
- git diff or explicit file list
- verification commands already run

## Ownership

- `adlc-implement` owns code changes and plan task status.
- `adlc-verify` owns evidence mapping and gate result.
- `adlc-review` owns correctness findings after verification.
- `adlc-commit` owns commit readiness after gates pass.

If verification finds a blocker, route back to `adlc-fix` or `adlc-implement`; do not patch during verify.
