# Hermes Handoff

Hermes is the execution runner. ADLC prepares the sprint package.

## Setup Checks

Run these before seeding:

```bash
command -v hermes
hermes profile list
hermes skills list | grep -E 'sprint-runner|kanban-orchestrator|kanban-worker'
hermes gateway status
```

If the gateway is not running:

```bash
hermes gateway start
```

Use real profiles from `hermes profile list`. A common local profile map is:

```text
sprintrunner    orchestration and Kanban graph creation
sprintbuilder   implementation and self-verification
sprintreviewer  hostile review
sprintfixer     review fixes, final verification, and commits
```

Use those names only if they exist on the current machine.

## Handoff File

Write `hermes-handoff.md` into the sprint package:

```markdown
# Hermes Handoff: <sprint name>

Sprint package: <absolute path>
Board: <board slug>
Workspace: dir:<absolute sprint package path> or worktree
Orchestrator: <profile>
Builder: <profile>
Reviewer: <profile>
Fixer: <profile>
Notification: <telegram/slack/none>

## Start Command

<exact seed command>

## Expected Graph

- item 01 build -> review -> fixes -> final verification -> commit/publish
- item 02 build depends on item 01 commit/publish

## Human Decisions

- <blocked decision or none>

## Watch

hermes kanban --board <board> list
hermes kanban --board <board> watch
```

## Preferred Seed Path

If the MetaModern Sprint Runner scripts are available, prefer the maintained seed script:

```bash
./scripts/seed-hermes-sprint.sh \
  --target-folder /absolute/path/to/docs/adlc/sprints/<slug> \
  --assignee sprintrunner \
  --instructions "Run this ADLC sprint end-to-end. Preserve build, self-verification, hostile review, review-fix, final verification, and commit/publication gates."
```

Use `--no-telegram` when notification is intentionally disabled. Use `--telegram-chat-id` when the home chat is not configured.

## Generic CLI Seed Path

When no seed script exists, create one orchestrator task:

```bash
hermes kanban boards create <board> \
  --name "<Sprint name>" \
  --description "ADLC sprint execution" \
  --switch

hermes kanban --board <board> create "<Sprint name>" \
  --assignee <orchestrator-profile> \
  --workspace "dir:/absolute/path/to/docs/adlc/sprints/<slug>" \
  --skill sprint-runner \
  --skill kanban-orchestrator \
  --body "<body>" \
  --json
```

The body should instruct the orchestrator to:

- read the sprint package
- discover profiles before assigning work
- create Kanban tasks for build, self-verification, hostile review, review fixes, final verification, and commit/publication
- link true dependencies with parent relationships
- keep HITL decisions as comments plus blocked tasks
- require worker handoffs with changed files, verification, findings, residual risk, and commit/publication metadata

## Task Body Template

```text
Use Sprint Runner to execute this ADLC sprint through Hermes Kanban.

Sprint package:
- <absolute path>

Lifecycle gates:
- Build with the ADLC build loop.
- Self-verify with the commands named in each work item.
- Run hostile review against the diff, acceptance criteria, and evidence.
- Create review-fix tasks for blocking findings.
- Run final verification after fixes.
- Commit or publish according to sprint-runner.yaml.

Rules:
- Discover available Hermes profiles before creating child tasks.
- Do not invent assignees.
- Preserve dependency links from sprint-runner.yaml.
- Use worktree workspaces for isolated code work when useful.
- Use Kanban comments and blocked state for human decisions.
- Continue until every item is done, deferred, or blocked with evidence.
```

## Watch And Recovery

```bash
hermes kanban --board <board> list
hermes kanban --board <board> watch
hermes kanban --board <board> diagnostics
hermes kanban --board <board> runs <task_id>
hermes kanban --board <board> reassign <task_id> <profile> --reclaim
hermes kanban --board <board> unblock <task_id>
```

Prefer a new review-fix task for findings. Do not erase failed attempts; the board history is part of the handoff.
