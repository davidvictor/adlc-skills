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
- release, migration, or monitoring evidence when applicable

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
   - browser screenshots that miss the changed state
   - release claims without smoke or rollback evidence
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

When another agent will continue from the proof, also include:

```json
{
  "adlc_phase": "prove",
  "evidence_verdict": "strong|partial|weak|blocked|absent",
  "blocking_gaps": [],
  "smallest_next_checks": [],
  "release_or_handoff_needed": false
}
```

## Rules

- Passing exit code is not enough if the command did not run the relevant work.
- "Not verified" is better than implied confidence.
- Blocked checks must name the missing condition.
- Recommendations should be executable by an agent or human.

## Runner Handoff

When running inside Hermes Kanban or another durable task runner, complete when the proof verdict is explicit. Block only when a missing credential, environment, destructive approval, or human decision prevents the proof from reaching a useful verdict.

## Escalation

- Use `adlc-build` if evidence is missing because implementation skipped the feedback loop.
- Use `adlc-diagnose` if a verification failure reveals an unexplained bug.
- Use `adlc-interface` or `adlc-polish` if visual proof exposes UI quality gaps.
- Use `adlc-release` if the claim is really about production readiness.
