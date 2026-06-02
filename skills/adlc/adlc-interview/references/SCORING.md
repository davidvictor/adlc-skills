# ADLC Interview Scoring

Use scoring to decide whether to keep interviewing or crystallize a spec.

## Dimensions

Score each dimension from `0.0` to `1.0`.

- Intent: why this matters and what problem it solves.
- Outcome: the desired end state.
- Scope: what is included and how far the change should go.
- Non-goals: what should stay out.
- Decision boundaries: what Codex may decide, what requires the user, and what requires external approval.
- Constraints: technical, business, schedule, migration, release, or operational limits.
- Success criteria: observable acceptance criteria and verification expectations.
- Context: brownfield repo evidence, affected surfaces, and unknowns.

## Formula

Use this weighted score:

```text
clarity =
  intent * 0.18 +
  outcome * 0.16 +
  scope * 0.14 +
  non_goals * 0.12 +
  decision_boundaries * 0.12 +
  constraints * 0.10 +
  success * 0.10 +
  context * 0.08

ambiguity = 1 - clarity
```

## Thresholds

- `quick`: continue while ambiguity is `> 0.30`.
- `standard`: continue while ambiguity is `> 0.20`.
- `deep`: continue while ambiguity is `> 0.15`.

## Readiness Overrides

Continue interviewing even below threshold when any readiness gate is missing:

- Non-goals explicit.
- Decision boundaries explicit.
- Pressure pass complete.
- Brownfield evidence separated from inference.
- Acceptance criteria testable.

## Progress Report Shape

```text
Round: <n>
Ambiguity: <score> / threshold <threshold>
Weakest dimension: <dimension>
Readiness gates: non-goals=<yes/no>, decision-boundaries=<yes/no>, pressure-pass=<yes/no>, evidence-vs-inference=<yes/no>, acceptance=<yes/no>
Next focus: <dimension or gate>
```
