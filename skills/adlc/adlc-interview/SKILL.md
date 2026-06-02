---
name: adlc-interview
description: Run an optioned ADLC clarification interview before planning, with scoring, repo evidence, and source-of-truth artifacts.
---

# ADLC Interview

Use this when a request is important but still underspecified: unclear intent, scope, non-goals, decision authority, acceptance criteria, architecture tradeoffs, or release risk.

Do not use this when the user asks to execute immediately, when a complete ADLC plan already exists, or when `adlc-grounded` can answer the question from evidence without interviewing.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Read repo guidance, description, architecture, rules, roadmap, active plans, and git status.
3. Inspect brownfield facts before asking questions. Do not ask the user for repo facts that can be discovered.
4. Create or update a context snapshot under `paths.interviews/<slug>/context.md`.
5. Run one question per round. Every question must include:
   - `Definitions`: plain-language terms needed to answer.
   - `Question`: one focused decision or clarification.
   - `Options`: lettered choices `A`, `B`, `C`, `D`, etc.
   - `Recommendation`: one option or a named blend, with a short reason.
6. Score ambiguity after each answer using `references/SCORING.md`.
7. Continue until ambiguity is at or below the selected threshold and readiness gates are satisfied.
8. Write the transcript and source-of-truth interview spec under `paths.interviews/<slug>/`.
9. Hand off to `adlc-plan`, `adlc-workstream`, `adlc-architecture`, `adlc-roadmap`, or `adlc-explore` using the spec path.

## Profiles

- `quick`: threshold `<= 0.30`, max 5 rounds.
- `standard`: threshold `<= 0.20`, max 12 rounds.
- `deep`: threshold `<= 0.15`, max 20 rounds.

Use `standard` by default.

## Readiness Gates

- Non-goals are explicit.
- Decision boundaries are explicit: what Codex may decide, what requires the user, and what requires external approval.
- At least one pressure pass revisits an earlier answer for evidence, hidden assumptions, tradeoffs, or root cause.
- Brownfield claims are separated into evidence and inference.
- Acceptance criteria are testable enough for `adlc-verify`.

## Question Rules

- Ask one question at a time.
- Prefer questions the user can answer with a letter.
- Offer a practical recommendation each round; do not pretend all options are equal.
- Keep definitions short and tied to the current question.
- Stay on the same unclear thread until it becomes materially clearer.
- Ask only questions that change plan scope, risk, architecture, release posture, or definition of done.

## Artifacts

Use templates in `templates/`:

- `CONTEXT.md`: preflight repo/context intake.
- `TRANSCRIPT.md`: round-by-round interview record.
- `SPEC.md`: source-of-truth clarified brief.

The final spec must include intent, outcome, in-scope work, non-goals, decision boundaries, constraints, acceptance criteria, evidence vs inference, pressure-pass findings, residual risk, and handoff recommendation.

## Handoff Contracts

- `adlc-plan`: Use the spec as binding requirements. Do not repeat the interview by default.
- `adlc-workstream`: Promote to milestones and step cards when the spec implies multi-sprint or goal-managed work.
- `adlc-architecture`: Use when unresolved choices are structural, integration, data, runtime, or ownership decisions.
- `adlc-roadmap`: Use when sequencing, milestones, or product direction should be durable before implementation.
- `adlc-explore`: Use only when evidence is still missing after the interview.

## Output

Report the interview root, transcript path, spec path, final ambiguity score, readiness-gate status, residual risks, and recommended next ADLC command.
