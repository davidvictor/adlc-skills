---
id: adlc-doc-workflow
type: guide
status: active
owner: ADLC
---

# Workflow

ADLC has two phases: project setup and the repeatable development loop.

## Project Setup

1. Install ADLC into the local agent runtime.
2. Initialize `.adlc/` in the target repo.
3. Fill in `DESCRIPTION.md`, `ARCHITECTURE.md`, and `RULES.md`.
4. Add roadmap, references, or area rules only when they clarify real work.

The setup skill `adlc` owns project context. It should not write plans or implement feature code.

## Development Loop

1. `adlc-explore` investigates options when the problem is unclear.
2. `adlc-grounded` answers from evidence when certainty matters more than ideation.
3. `adlc-architecture`, `adlc-roadmap`, `adlc-rules`, and `adlc-reference` create durable context only when needed.
4. `adlc-plan` writes executable task plans.
5. `adlc-workstream` creates staged epic workstreams when the scope needs long-running Codex or Hermes handoff.
6. `adlc-improve` tightens plans before implementation.
7. `adlc-implement` executes selected tasks with coordinator, workers, and read-only sidecars.
8. `adlc-verify` proves completion against plan, rules, and repo behavior.
9. `adlc-rules-check`, `adlc-security-checklist`, `adlc-docs`, and `adlc-qa` add optional gates and artifacts.
10. `adlc-review` checks diffs for correctness, maintainability, security, docs, and release risk.
11. `adlc-commit` stages and commits verified work.
12. `adlc-evolve` promotes repeated lessons into rules or skill-context.

## Workstream Loop

Workstreams are for epics that will not finish in one session. A workstream step moves through `ready -> build -> review -> test -> commit -> done`, with `blocked` available at every point.

Codex steps are executed with normal ADLC implementation, verification, review, and commit commands. Hermes steps are exported as Kanban-ready cards; Hermes owns its board state after handoff while ADLC preserves the source artifact and step IDs.

## Artifact Ownership

Each command has a primary write surface. Gates are read-only unless the user explicitly asks for a fix. This prevents agents from fighting over the same files and keeps handoffs clear.

## Stop Conditions

Stop and report clearly when:

- a requested change conflicts with rules or architecture
- verification cannot prove completion
- a destructive action would be required
- a human product decision materially changes scope
- a gate produces a blocking `adlc-gate-result`
