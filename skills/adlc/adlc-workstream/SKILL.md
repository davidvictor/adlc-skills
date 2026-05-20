---
name: adlc-workstream
description: Plan grounded long-running workstreams with staged Codex or Hermes handoffs.
---

# ADLC Workstream

Use this when an epic is too large for one plan execution pass and needs durable step cards, Kanban state, and executor handoffs.

## Process

1. Resolve effective ADLC paths from `.adlc/config.yaml`; use `adlc resolve-config` when the CLI is available.
2. Ground the epic in live repo evidence, existing plans, architecture, rules, and user constraints before creating steps.
3. Before external delegation, inspect the dirty tree. Commit small coherent existing work first; stop and ask for large, mixed, or unrelated dirty trees.
4. Create or update `paths.workstreams/<slug>/` with a workstream overview, Kanban board, step cards, and executor handoffs.
5. Break the epic into independent steps that can move through `build -> review -> fix -> test -> commit`, with review/fix/test loops handled autonomously unless a human-gated blocker is explicit.
6. Assign each step an executor lane: `codex`, `hermes`, or `either`.
7. For Codex handoff, include the exact ADLC plan/step path, bounded write scope, verification commands, and expected gate outputs.
8. For Hermes handoff, create a Kanban-ready card contract that Hermes can import into its own board without losing ADLC artifact IDs.
9. Keep blocked decisions explicit and avoid inventing dependencies that are not supported by evidence.

## Rules

- Workstreams coordinate execution; they do not replace `adlc-plan`, `adlc-implement`, `adlc-verify`, `adlc-review`, or `adlc-commit`.
- Every step must have evidence, scope, acceptance criteria, verification, commit checkpoint, and next-stage rules.
- Codex manages Hermes boards for ADLC handoff; Hermes owns task execution and board progression after import.
- Hermes worker profiles should use Codex GPT-5.5 with xhigh reasoning unless a target project overrides the profile.
- Ask before using a Hermes worktree unless the target project config or user request already requires one.
- Hermes owns its own Kanban once a card is handed off; ADLC owns the source workstream artifact and exported handoff contract.
- Review, fix, and test gates are autonomous by default. A failed gate with actionable code, docs, tests, rules, or security findings should route to the next ADLC gate or fixer, then return to review/verify without operator approval.
- Use human-blocked only for explicit human decisions, credentials or external accounts, destructive or production operations, legal/security sign-off, scope or product ambiguity, or a user-requested approval point.
- Do not encode an ordinary post-fix `review-required` handoff as a human blocker. Create or advance an autonomous review/verify gate, or mark the fix complete with the downstream gate pending.
- Do not create Hermes-specific runners or hidden automation. ADLC exports work; executors perform it through their normal lifecycle.
- Do not stop global worker services while stopping a task. Gateway, daemon, scheduler, or service shutdown requires an explicit operator request.
- Long-running state must live in files, not chat memory.

## Output

Report the workstream root, step count, executor lanes, blocked decisions, current Kanban state, and the next runnable step for Codex or Hermes.
