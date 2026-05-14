---
name: adlc-prove
description: Audit verification claims and identify weak, skipped, partial, stale, or no-op evidence. Use when a PR, closeout, or agent summary says tests passed, verification is done, checks are green, or work is complete.
---

# ADLC Prove

Check whether the evidence proves the claim.

## Inputs

- closeout summary
- commands and outputs
- changed files
- test config
- CI status
- intended behavior or PRD
- screenshots or manual QA notes

## Process

1. Extract every verification claim.
2. Map each claim to evidence.
3. Check whether the evidence exercised the intended behavior.
4. Identify:
   - no-op commands
   - skipped projects
   - stale selectors
   - missing auth or fixture state
   - tests unrelated to changed behavior
   - manual checks without observable evidence
   - CI/local mismatch
5. Classify evidence:
   - strong
   - partial
   - weak
   - blocked
   - absent
6. Recommend the smallest additional check that would improve confidence.

## Output

```markdown
| Claim | Evidence | Verdict | Gap | Next Check |
| --- | --- | --- | --- | --- |
```

## Rules

- Passing exit code is not enough if the command did not run the relevant work.
- "Not verified" is better than implied confidence.
- Blocked checks must name the missing condition.
- Recommendations should be executable by an agent or human.
