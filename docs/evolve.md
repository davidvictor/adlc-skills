---
id: adlc-doc-evolve
type: guide
status: active
owner: ADLC
---

# Evolve

`adlc-evolve` is the continuous-improvement loop for ADLC.

## Inputs

- configured patch notes
- recent gate failures
- repeated review findings
- stale or missing project rules
- weak skill instructions discovered during real work

## Outputs

Prefer project-local learning first:

- configured `paths.skill_context`
- configured base rules file
- configured area rules

Update this ADLC package only when the lesson is cross-project and stable.

## Good Evolution Candidates

- a recurring missed verification step
- repeated scope drift
- a common project-specific rule
- unclear artifact ownership
- a gate output that automation cannot parse

## Bad Evolution Candidates

- one-off taste preferences
- task-specific implementation details
- rules that contradict repo guidance
- broad process expansion without repeated evidence

