---
id: adlc-doc-interviews
type: guide
status: active
owner: ADLC
---

# Interviews

`adlc-interview` turns ambiguity into a source-of-truth brief before planning or workstream creation.

Use it when a request has material uncertainty around intent, outcome, scope, non-goals, decision authority, acceptance criteria, architecture tradeoffs, sequencing, or release risk.

## Artifact Root

Interview artifacts live under configured `paths.interviews`, default `.adlc/interviews/`.

A normal interview folder contains:

- `context.md`: repo/context intake, brownfield evidence, and assumptions.
- `transcript.md`: one-question rounds, answers, scores, and pressure-pass notes.
- `spec.md`: clarified source-of-truth brief for downstream ADLC work.

## Preflight

Before asking questions, collect repo evidence:

- ADLC config and resolved paths
- `DESCRIPTION.md`, `ARCHITECTURE.md`, `RULES.md`, roadmap, active plans, and workstreams
- repo guidance files such as `AGENTS.md`
- git status and recent local changes
- relevant source files, tests, docs, schemas, APIs, or runtime output

Ask the user for decisions, priorities, or preferences. Do not ask for facts that the repo can provide.

## One-Question Rounds

Each round asks one focused question and uses this shape:

```markdown
Definitions:
- Decision boundary: who may decide what during implementation.
- Non-goal: work that is deliberately outside the current scope.

Question:
What boundary should govern implementation autonomy?

Options:
A. Codex may decide local implementation details inside the accepted plan.
B. Codex must ask before changing public contracts, data models, or release behavior.
C. Codex must ask before each material implementation choice.
D. Blend A and B: local details are autonomous, contract and release changes are user-gated.

Recommendation:
D, because it keeps execution moving while preserving authority over durable surfaces.
```

Definitions must be short, plain-language, and specific to the current question. Options should be lettered, mutually understandable, and concrete enough that the user can answer with a letter or a named blend.

## Scoring

Score ambiguity after each answer with `skills/adlc/adlc-interview/references/SCORING.md`.

The interview is ready for handoff when the selected profile threshold is met and all readiness gates pass:

- non-goals are explicit
- decision boundaries are explicit
- at least one pressure pass has challenged assumptions or tradeoffs
- brownfield claims separate evidence from inference
- acceptance criteria are testable enough for `adlc-verify`

## Handoff

The final spec should tell downstream skills what to do next:

- `adlc-plan`: create executable tasks from the clarified brief.
- `adlc-workstream`: promote large or multi-sprint scopes into milestones and step cards.
- `adlc-architecture`: settle structural, data, runtime, integration, or ownership decisions.
- `adlc-roadmap`: preserve sequencing or product direction before planning.
- `adlc-explore`: gather missing evidence that remained unavailable during the interview.

Plans, workstreams, and architecture updates should cite the spec path and preserve its non-goals, decision boundaries, pressure-pass findings, and acceptance criteria.
