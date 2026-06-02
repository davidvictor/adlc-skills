---
name: adlc-workstream
description: Plan grounded long-running workstreams with Codex goal-managed execution.
---

# ADLC Workstream

Use this when an epic is too large for one plan execution pass and needs durable Codex goal context, milestone sequencing, step cards, Kanban state, and execution handoffs.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Ground the epic in live repo evidence, relevant interview specs, existing plans, architecture, rules, and user constraints before creating steps.
3. For long-running or multi-sprint execution, create or attach the active Codex goal and record the goal objective in `WORKSTREAM.md`.
4. Inspect the dirty tree before delegation. Commit small coherent existing work first; stop and ask for large, mixed, or unrelated dirty trees.
5. Create or update `paths.workstreams/<slug>/` with a workstream overview, Kanban board, evidence log, decision log, milestone cards, step cards, and Codex handoff.
6. Decompose the epic as `workstream -> milestone -> step -> task`. Each step should be one reviewable, commit-capable slice with a bounded write scope.
7. Move each step through `ready -> build -> review -> fix -> test -> commit -> done`, with review/fix/test loops handled autonomously unless a human-gated blocker is explicit.
8. Assign each step an execution lane: `coordinator`, `worker`, `parallel`, or `human-gated`.
9. For Codex handoff, include the exact ADLC workstream/step path, bounded write scope, verification commands, expected gate outputs, and goal-continuity instructions.
10. Keep blocked decisions explicit and avoid inventing dependencies that are not supported by evidence.

## Rules

- Workstreams coordinate execution; they do not replace `adlc-plan`, `adlc-implement`, `adlc-verify`, `adlc-review`, or `adlc-commit`.
- Codex goals manage the active long-running objective. ADLC artifacts remain the detailed source of truth for scope, state, evidence, and decisions.
- Interview specs remain binding clarification artifacts. Carry their non-goals, decision boundaries, pressure-pass findings, and acceptance criteria into milestones and step cards.
- Every milestone must have a concrete outcome, dependency notes, exit criteria, and release or rollback considerations when relevant.
- Every step must have evidence, scope, acceptance criteria, verification, commit checkpoint, and next-stage rules.
- Split any step whose acceptance criteria span unrelated subsystems, cannot be verified in one pass, or would create a mixed commit.
- Review, fix, and test gates are autonomous by default. A failed gate with actionable code, docs, tests, rules, or security findings should route to the next ADLC gate or fixer, then return to review/verify without operator approval.
- Use human-blocked only for explicit human decisions, credentials or external accounts, destructive or production operations, legal/security sign-off, scope or product ambiguity, or a user-requested approval point.
- Do not encode an ordinary post-fix `review-required` handoff as a human blocker. Create or advance an autonomous review/verify gate, or mark the fix complete with the downstream gate pending.
- Do not create hidden automation. ADLC exports work; execution lanes perform it through their normal Codex lifecycle.
- Do not stop global worker services while stopping a task. Gateway, daemon, scheduler, or service shutdown requires an explicit operator request.
- Long-running state must live in ADLC artifacts and Codex goal status, not chat memory.

## Output

Report the workstream root, Codex goal status, milestone count, step count, execution lanes, blocked decisions, current Kanban state, and the next runnable Codex step.
