---
id: adlc-doc-workflow
type: guide
status: active
owner: ADLC
---

# Workflow

ADLC has two phases: project setup and the repeatable development loop.

## Project Setup

1. Install ADLC with `npm install -g adlc-cli`.
2. Initialize `.adlc/` and selected agent targets in the target repo.
3. Fill in `DESCRIPTION.md`, `ARCHITECTURE.md`, and `RULES.md`.
4. Add roadmap, references, or area rules only when they clarify real work.

The setup skill `adlc` owns project context. It should not write plans or implement feature code.

## Delegation Intake

Before planning or launching an external worker, inspect the target repo status
and decide whether the current work needs a checkpoint.

- If the dirty tree is small, coherent, and clearly related to the requested
  work, commit it first with an accurate conventional message.
- If the dirty tree is large, mixed, unrelated, or hard to classify, stop and
  ask the operator how to handle it.
- Do not hand a dirty tree to a worker unless the workstream or operator has
  explicitly chosen that state.

## Development Loop

1. `adlc-explore` investigates options when the problem is unclear.
2. `adlc-grounded` answers from evidence when certainty matters more than ideation.
3. `adlc-architecture`, `adlc-roadmap`, `adlc-rules`, and `adlc-reference` create durable context only when needed.
4. `adlc-plan` writes executable task plans.
5. `adlc-workstream` creates staged epic workstreams when the scope needs Codex goal continuity across sessions.
6. `adlc-improve` tightens plans before implementation.
7. `adlc-implement` executes selected tasks with coordinator, workers, and read-only sidecars.
8. `adlc-verify` proves completion against plan, rules, and repo behavior.
9. `adlc-rules-check`, `adlc-security-checklist`, `adlc-docs`, and `adlc-qa` add optional gates and artifacts.
10. `adlc-review` checks diffs for correctness, maintainability, security, docs, and release risk.
11. `adlc-commit` stages and commits verified work.
12. `adlc-evolve` promotes repeated lessons into rules or skill-context.

## Workstream Loop

Workstreams are for epics that will not finish in one session. A workstream step moves through `ready -> build -> review -> fix -> test -> commit -> done`, with `blocked` available at every point.

Codex goals carry the active objective. ADLC workstream files carry the detailed milestone, step, evidence, decision, gate, and commit state. Codex executes steps with normal ADLC implementation, verification, review, and commit commands.

Stopping a global worker service is never implied by stopping one task. Stop
only the worker/session/process launched for the current task. A gateway,
daemon, scheduler, or global service may be stopped only when the operator asks
for that exact service to stop.

## Mainline Closeout

When the requested destination is `main`, close the loop explicitly:

1. Commit the finished feature branch or working branch.
2. Run the strongest practical verification gate.
3. Merge or fast-forward the verified work into `main`.
4. Push `main` to `origin`.
5. Record release proof: current branch, clean status, relevant gate output,
   local `main` SHA, remote `origin/main` SHA, and divergence count.

## Artifact Ownership

Each command has a primary write surface. Gates are read-only unless the user explicitly asks for a fix. This prevents agents from fighting over the same files and keeps handoffs clear.

## Stop Conditions

Stop and report clearly when:

- a requested change conflicts with rules or architecture
- verification cannot prove completion
- a destructive action would be required
- a human product decision materially changes scope
- a gate produces a blocking `adlc-gate-result`
