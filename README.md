# ADLC

ADLC is an agent-driven development lifecycle for moving work from project context to plan, implementation, verification, review, and commit readiness.

It packages:

- ADLC skills and workflow guidance
- Codex-native coordinator, worker, and sidecar agents
- Claude project skill and MCP setup
- Hermes workstream handoff and Kanban state
- project-local lifecycle artifacts under `.adlc/`
- a small CLI for install, update, status, extensions, workstreams, and artifact audits

ADLC keeps operator documentation under [docs/](./docs/README.md) so the workflow is visible, repeatable, and easy to maintain.

## Install

The public package name is `adlc-cli`. The installed command is `adlc`.

```bash
npm install -g adlc-cli
cd /path/to/project
adlc init --agents codex,claude,hermes --mcp github,playwright
adlc status --strict
```

Run without a global install:

```bash
npx adlc-cli init /path/to/project --agents codex,claude,hermes --mcp filesystem
npx adlc-cli status /path/to/project --strict
```

## Agent Targets

ADLC supports three agent targets for the public installer:

- `codex`: installs ADLC skills into `.codex/skills/`, Codex TOML agents into `.codex/agents/`, and managed Codex config into `.codex/config.toml`.
- `claude`: installs ADLC skills into `.claude/skills/` and configures MCP servers through `.mcp.json`.
- `hermes`: installs `.hermes/config.yaml`, `.hermes/kanban.json`, `.hermes/workstreams/`, and `.hermes/inbox/` for managed workstream execution.

Inspect supported targets:

```bash
adlc agents
adlc agents --json
```

Managed install state is project-local at `.adlc/managed-state.json`.

## CLI

```bash
adlc init [target-dir] --agents codex,claude,hermes --mcp github,playwright
adlc update [target-dir]
adlc status [target-dir] --strict
adlc doctor [target-dir]
adlc uninstall [target-dir] --agents codex,claude,hermes
adlc resolve-config [target-dir] --json
adlc audit-artifacts [targets...] --strict
```

MCP templates:

```bash
adlc mcp list
adlc mcp configure filesystem /path/to/project --agents codex,claude
adlc mcp remove filesystem /path/to/project --agents codex,claude
```

Extensions:

```bash
adlc extension validate extensions/marketplace/hello-adlc
adlc extension add extensions/marketplace/hello-adlc /path/to/project --agents codex,claude
adlc extension list /path/to/project
adlc extension remove hello-adlc /path/to/project
```

## Workflow

```text
adlc
  -> adlc-explore or adlc-grounded
  -> optional adlc-architecture / adlc-roadmap / adlc-rules / adlc-reference
  -> adlc-plan
  -> optional adlc-workstream for long-running epics
  -> adlc-improve
  -> adlc-implement
  -> adlc-verify
  -> optional adlc-rules-check / adlc-security-checklist / adlc-docs / adlc-qa
  -> adlc-review
  -> adlc-commit
  -> optional adlc-loop for bounded iteration
  -> adlc-evolve when there is reusable learning
```

Bug work can enter through `adlc-fix`, then continue to `adlc-verify`, `adlc-review`, and `adlc-commit`.

## Workstreams

ADLC workstreams turn large scopes into independent step cards that can move through build, review, test, and commit stages.

```bash
adlc workstream create project-automation /path/to/project --executor either
adlc workstream status project-automation /path/to/project
adlc workstream advance project-automation 0001 /path/to/project --stage build
adlc workstream sync project-automation /path/to/project --agent hermes
```

Hermes sync writes cards to `.hermes/workstreams/`, updates `.hermes/kanban.json`, and drops a handoff in `.hermes/inbox/`.

## Skills

Use these skills as the public workflow interface:

1. `adlc` - initialize or refresh `.adlc/` context.
2. `adlc-explore` - investigate options without committing to a plan.
3. `adlc-grounded` - answer from evidence only when guessing is unacceptable.
4. `adlc-architecture` - create or refresh architecture artifacts from repo evidence.
5. `adlc-roadmap` - maintain milestones and long-range sequencing.
6. `adlc-rules` - capture project rules and area conventions.
7. `adlc-reference` - create durable reference artifacts from sources.
8. `adlc-plan` - create fast or full implementation plans.
9. `adlc-workstream` - plan epic workstreams for Codex or Hermes handoff.
10. `adlc-improve` - tighten an existing plan before implementation.
11. `adlc-implement` - execute a plan with Codex coordinators, workers, and sidecars.
12. `adlc-verify` - prove completion against plan, rules, and repo behavior.
13. `adlc-rules-check` - run a separate read-only rules gate.
14. `adlc-security-checklist` - run a separate read-only security gate.
15. `adlc-review` - review diffs for correctness, maintainability, and risk.
16. `adlc-docs` - audit and update lifecycle documentation.
17. `adlc-qa` - create change summaries, test plans, and manual test cases.
18. `adlc-commit` - prepare conventional commits from staged work.
19. `adlc-fix` - diagnose, fix, and record a learning patch.
20. `adlc-loop` - run bounded iterative improvement loops.
21. `adlc-evolve` - turn patches and repeated findings into durable rules or skill updates.

## Documentation

- [Getting Started](./docs/getting-started.md)
- [Workflow](./docs/workflow.md)
- [Configuration](./docs/configuration.md)
- [Config Reference](./docs/config-reference.md)
- [Agent Targets](./docs/agents.md)
- [Skills](./docs/skills.md)
- [Subagents](./docs/subagents.md)
- [Plan Files](./docs/plan-files.md)
- [Workstreams](./docs/workstreams.md)
- [Quality Gates](./docs/quality-gates.md)
- [Loop](./docs/loop.md)
- [Evolve](./docs/evolve.md)
- [MCP](./docs/mcp.md)
- [Extensions](./docs/extensions.md)
- [Artifact Audit](./docs/artifact-audit.md)
- [Security](./docs/security.md)
- [Gate Results](./docs/gate-result-schema.md)

## Validation

```bash
npm run validate
npm run test:cli
npm run test:skill-fixtures
adlc audit-artifacts --strict docs README.md AGENTS.md
npm run pack:dry-run
```

Validation fails when required skills or agents are missing, package metadata drifts from the public install contract, managed installer docs drift from the CLI, or artifact metadata breaks.
