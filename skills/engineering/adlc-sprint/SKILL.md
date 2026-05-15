---
name: adlc-sprint
description: Assemble multiple ADLC PRDs, slices, or briefs into an execution-ready sprint package for a human runner, tracker, or Kanban orchestrator.
---

# ADLC Sprint

Package planned work into a sprint that another runner can execute.

Use this after `adlc-plan`, `adlc-shape`, and `adlc-slice` when the user has multiple PRDs, issue drafts, or agent briefs that should move together through implementation, review, verification, and publication.

## Process

1. Read `docs/adlc/operating-contract.md`, if present.
2. Read the source PRDs, specs, issue drafts, agent briefs, and handoff notes. If the source is a folder, use [SPRINT-MATERIALS.md](./SPRINT-MATERIALS.md).
3. Reject or return to planning any item that lacks target behavior, acceptance criteria, verification, repo ownership, or release posture.
4. Normalize each item using [SPRINT-PACKAGE.md](./SPRINT-PACKAGE.md).
5. Decide item order, dependencies, write scope, isolation mode, verification, and publication mode. Use [EXECUTION-ARCHITECTURES.md](./EXECUTION-ARCHITECTURES.md) when the runner topology is not obvious.
6. Mark each item as:
   - **AFK**: execution can proceed without human decisions.
   - **HITL**: a human decision, credential, design approval, or production judgment is still needed.
7. Write the sprint package under `docs/adlc/sprints/<slug>/` unless the operating contract or user names another location.
8. If the user wants Hermes execution, recommend `adlc-hermes` after the package is ready.

## Rules

- Do not implement sprint items.
- Do not hide unresolved decisions inside broad "implementation" tasks.
- Do not group unrelated work just because it is available at the same time.
- Prefer thin reviewable items over one large sprint item.
- Preserve true dependencies and leave independent items unlinked.
- Include verification and commit/publication expectations per touched repo.
- Keep runner-specific setup out of the core sprint package unless the user requests a specific runner.

## Output Contract

The default package is:

```text
docs/adlc/sprints/<slug>/
  README.md
  adlc-sprint.yaml
  work-items/
    01-<slug>.md
  handoff.md
```

If the sprint is not ready, produce a normalization report with blockers instead of a fake package.

## Closeout

Report:

- sprint package path
- source PRDs, slices, and briefs included
- AFK/HITL split
- dependency graph
- verification and publication policy
- whether it is ready for `adlc-hermes`, another runner, or more planning
