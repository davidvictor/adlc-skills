# Hermes Handoff

Hermes is the execution runner. ADLC prepares the sprint package.

## Setup Checks

Run these before seeding:

```bash
command -v hermes
hermes version
hermes profile list
hermes skills list | grep -E 'kanban-orchestrator|kanban-worker'
hermes skills list | grep -E 'adlc-build|adlc-audit|adlc-close|adlc-prove|adlc-release|adlc-handoff'
hermes gateway status
hermes status
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

If the `adlc-*` skills are missing from Hermes, install them from the ADLC repo. Run this from the ADLC skills checkout, not from an installed skill copy:

```bash
cd /Users/davidvictor/.codex/workspaces/default/repos/adlc-skills
scripts/install-hermes-adlc-skills.sh
```

To create and configure the common sprint profiles, run:

```bash
cd /Users/davidvictor/.codex/workspaces/default/repos/adlc-skills
scripts/setup-hermes-adlc-profiles.sh
```

For a repeatable preflight, run:

```bash
cd /Users/davidvictor/.codex/workspaces/default/repos/adlc-skills
scripts/check-hermes-adlc-ready.sh
```

The healthcheck should confirm:

- Hermes is available and authenticated enough for the selected provider.
- The gateway is running.
- worker profiles exist and use `model.openai_runtime=auto` when OpenAI Codex is the provider.
- `kanban-worker`, `kanban-orchestrator`, and ADLC phase skills are visible.
- the target board has no obvious stuck tasks before adding more work.
- required messaging platforms are configured. For Telegram-watched boards,
  `hermes status` must show Telegram configured and the seed command must create
  subscriptions.

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

- item 01 build completes with review_required=true
- item 01 hostile review completes with approved=true or approved=false plus finding ledger
- item 01 review fixes complete with fix plan, findings_resolved, verification, and commit_hashes when commits are in scope
- item 01 final verification completes with evidence verdict and residual risk
- item 02 build depends on item 01 commit/publish

## Notification Flow

- Telegram subscriptions send a message when each phase starts and when it completes, blocks, gives up, crashes, or times out.
- `🚨 Hermes needs your attention` means the operator should open Codex mobile, inspect the task, then comment, edit, reassign, or unblock it.
- Assignees are Hermes profile labels, not Telegram usernames. Do not write `@<profile>` mentions such as `@Sprint Runner`.
- If `adlc-sprint.yaml` sets `runner.notifications: "telegram"`, Telegram is
  required. Do not seed with `--no-telegram`. After seeding, run
  `hermes kanban --board <board> notify-list` and verify every active or pending
  task has the expected `telegram:<chat_id>` subscription.

## ADLC Skill Map

- build: `adlc-build`
- hostile review: `adlc-audit`
- review fixes: `adlc-close`
- final verification proof: `adlc-prove`
- release readiness: `adlc-release`
- continuity: `adlc-handoff`

## Human Decisions

- <blocked decision or none>

## Blocked State Rules

Use blocked state only for:

- `human-decision:` planning, product, or scope decisions
- `credential-blocker:` missing auth, secrets, browser session, or account state
- `environment-blocker:` missing local tooling or unavailable services
- `scope-expansion:` work outside the approved sprint item
- `unsafe-verification:` destructive or production-risk checks

Do not block with `review-required:`. Review is the next phase and should be reached by completing the build task.

## Watch

hermes kanban --board <board> list
hermes kanban --board <board> watch
```

## Preferred Seed Path

Use the ADLC seeder from the ADLC skills checkout:

```bash
cd /Users/davidvictor/.codex/workspaces/default/repos/adlc-skills
scripts/seed-adlc-hermes-sprint.sh \
  --target-folder /absolute/path/to/docs/adlc/sprints/<slug> \
  --assignee sprintrunner \
  --instructions "Run this ADLC sprint end-to-end in automated mode. Use ADLC phase skills in child tasks: adlc-build for build, adlc-audit for hostile review, adlc-close for review fixes, adlc-prove for final verification proof, adlc-release when release risk exists, and adlc-handoff for continuity. Build tasks complete into hostile review; they do not block merely because review is required. Preserve build, self-verification, hostile review, review-fix, final verification, and commit/publication gates."
```

Use `--no-telegram` only when notification is intentionally disabled and the
manifest does not require Telegram. Use `--telegram-chat-id` when the home chat
is not configured. If the manifest sets `runner.notifications: "telegram"`, the
seeder refuses `--no-telegram`, refuses a real seed with no Telegram chat id,
fails on subscription errors, and verifies `notify-list` before dispatch. With
Telegram enabled, expect lifecycle pings for phase start, phase completion, and
human-attention states; blocked and gave-up messages are the operator interrupt
path.

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
  --skill adlc-hermes \
  --skill kanban-orchestrator \
  --body "<body>" \
  --json
```

The body should instruct the orchestrator to:

- read the sprint package
- discover profiles before assigning work
- create Kanban tasks for build, self-verification, hostile review, review fixes, final verification, and commit/publication
- assign each task the relevant ADLC phase skill
- link true dependencies with parent relationships
- keep HITL decisions as comments plus blocked tasks
- complete normal phase gates so dependent tasks promote automatically
- require worker handoffs with changed files, verification, findings, residual risk, and commit/publication metadata

## Task Body Template

```text
Use ADLC Hermes to execute this ADLC sprint through Hermes Kanban.

Sprint package:
- <absolute path>

Lifecycle gates:
- Build with `adlc-build`.
- Self-verify with the commands named in each work item.
- Run hostile review with `adlc-audit` against the diff, acceptance criteria, and evidence.
- Create review-fix tasks with `adlc-close` for blocking findings.
- Run final verification proof with `adlc-prove` after fixes.
- Use `adlc-release` for production, migration, integration, or user-facing release risk.
- Use `adlc-handoff` for continuity and exact next steps.
- Commit or publish according to `adlc-sprint.yaml`.

Rules:
- Discover available Hermes profiles before creating child tasks.
- Do not invent assignees.
- Do not assume ADLC skills are installed; verify them before assigning them.
- Preserve dependency links from `adlc-sprint.yaml`.
- Use worktree workspaces for isolated code work when useful.
- Use Kanban comments and blocked state for human decisions, missing credentials, missing environments, destructive approvals, unsafe verification, or scope expansion.
- Do not use blocked state for ordinary review handoff. Build completes into audit; audit completes into close/prove; close completes into proof/handoff.
- Keep notifications actionable: blocked or gave-up tasks should include the exact reason and what a human can change from Codex mobile.
- Continue until every item is done, deferred, or blocked with evidence.
```

## Watch And Recovery

```bash
hermes kanban --board <board> list
hermes kanban --board <board> notify-list
hermes kanban --board <board> watch
hermes kanban --board <board> diagnostics
hermes kanban --board <board> runs <task_id>
hermes kanban --board <board> log <task_id>
hermes kanban --board <board> reassign <task_id> <profile> --reclaim
hermes kanban --board <board> unblock <task_id>
```

If a task is blocked with a stale `review-required:` reason and has a complete build handoff, convert it to a completion or unblock it so the review child can promote. Prefer a new review-fix task for findings. Do not erase failed attempts; the board history is part of the handoff.
