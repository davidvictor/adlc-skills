---
id: adlc-doc-config-reference
type: reference
status: active
owner: ADLC
---

# Config Reference

Default config lives in [templates/adlc/config.yaml](../templates/adlc/config.yaml).

## `paths`

- `root`: ADLC artifact root. Default `.adlc`.
- `description`: project description.
- `architecture`: architecture source of truth, owned by `adlc-architecture`.
- `roadmap`: roadmap artifact.
- `rules_file`: base rules file.
- `rules`: area rules directory.
- `research`: exploration notes.
- `plan`: fast-plan file.
- `plans`: full-plan directory.
- `fixes`: fix-plan directory.
- `patches`: learning patch directory.
- `skill_context`: skill-context overrides.
- `references`: durable source/reference notes.
- `qa`: QA artifact root.
- `loops`: loop iteration notes.
- `workstreams`: long-running epic workstreams and executor handoffs.

## `workflow`

- `default_plan_mode`: default planning mode, usually `full`.
- `plan_id_format`: currently `slug`.
- `commit_checkpoints`: whether plans should include commit boundaries.
- `verify_before_review`: whether verify should precede review.
- `review_before_commit`: whether review should precede commit.
- `evolve_from_patches`: whether patch notes should feed `adlc-evolve`.

## `git`

- `enabled`: whether ADLC should use git context.
- `create_branches`: whether plans may create branches by default.
- `base_branch`: expected integration base, usually `main`.

## `agents`

Names the preferred coordinator, worker, sidecar, and commit-preparer agents. These names align with files in `subagents/codex/agents/`.
