# Execution Architectures

Use this reference when deciding how a sprint should run across multiple PRDs, repos, or review surfaces.

## Principle

Model the sprint as an ordered changeset queue. A PR is a review or publication artifact. A branch or worktree is an isolation mechanism. Durable sprint state belongs in the normalized item records, handoff, verification evidence, and optional runner board.

## Options

### In-Place Sequential Commits

Best when one active runner owns an ordered queue in a known workspace.

Flow: preflight, edit, verify, hostile review, fixes, final verify, commit, next item.

This is the lowest-overhead default, especially for documentation and strictly serialized work. It requires clean commits after each item and careful separation from pre-existing user changes.

### Worktree Per Item

Best when items need filesystem isolation, parallel verification, or review sandboxes.

Flow: create worktree from a known base, implement item, verify, review, commit, publish or merge/cherry-pick, remove the worktree after evidence is captured.

This helps parallel agents avoid trampling each other, but it adds setup cost and does not solve cross-repo atomicity by itself.

### Stacked PRs

Best when items are dependent changes in one repo and reviewers need small diffs.

Flow: item 1 targets the base branch, item 2 targets item 1, item 3 targets item 2, and so on.

This preserves reviewability for dependent work. It is fragile if the repo workflow does not support stack updates cleanly.

### Cross-Repo Changeset

Best when one item requires coordinated edits in multiple repos.

Flow: one item record owns multiple repo-local commits, per-repo verification, compatibility notes, rollback notes, and linked publication artifacts.

This reflects real product boundaries better than forcing a monorepo model. Atomic merge is usually social or tooling-driven, so integration verification matters.

### Tracker-First Queue

Best when Linear, GitHub Issues, Jira, or another tracker is the authoritative queue.

Flow: pull ordered issues, normalize item records, execute each item, update the tracker with evidence.

Tracker metadata rarely contains enough implementation detail; each item still needs repo, scope, acceptance, and verification fields.

## Selection Heuristic

1. If items are ordered and one runner is active, use in-place sequential commits.
2. If items can run concurrently or need clean diff sandboxes, use worktrees.
3. If dependent same-repo changes need small review surfaces, use stacked PRs.
4. If an item spans repos, use a cross-repo changeset record.
5. If an external tracker is authoritative, keep tracker ids in the item records but do not rely on tracker prose as the implementation contract.

## Anti-Patterns

- Using branch names as the only sprint state.
- Treating "PR" as synonymous with "branch".
- Combining unrelated repo changes because they share a calendar sprint.
- Running a later item before review fixes and final verification are recorded for its dependency.
- Hiding production, credential, or billing decisions inside a broad implementation task.
