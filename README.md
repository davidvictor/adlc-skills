# ADLC

ADLC is David Victor's agent-driven development lifecycle, rebuilt on the useful parts of the AI Factory architecture.

This repo is a lean command pipeline with ADLC-owned artifacts and Codex-native agents. The goal is not to mirror every upstream AI Factory feature. The goal is the smallest system that matches how David actually works:

- repo-local context and plans under `.adlc/`
- a short command surface that routes work instead of a broad menu of lifecycle skills
- native Codex coordinators, workers, and read-only sidecars
- explicit artifact ownership so agents do not fight over the same files
- implementation that ends in verification, review, commit readiness, and a clear handoff

The upstream comparison source is [lee-to/ai-factory](https://github.com/lee-to/ai-factory). ADLC keeps its own documentation under [docs/](./docs/README.md) so the operating model is ours, not a borrowed upstream manual.

## Documentation

- [Getting Started](./docs/getting-started.md)
- [Workflow](./docs/workflow.md)
- [Configuration](./docs/configuration.md)
- [Config Reference](./docs/config-reference.md)
- [Skills](./docs/skills.md)
- [Subagents](./docs/subagents.md)
- [Plan Files](./docs/plan-files.md)
- [Workstreams](./docs/workstreams.md)
- [Quality Gates](./docs/quality-gates.md)
- [Loop](./docs/loop.md)
- [Evolve](./docs/evolve.md)
- [Runtimes](./docs/runtimes.md)
- [MCP](./docs/mcp.md)
- [Extensions](./docs/extensions.md)
- [Artifact Audit](./docs/artifact-audit.md)
- [Security](./docs/security.md)

## Command Surface

Use these skills as the public interface:

1. `adlc` - initialize or refresh `.adlc/` context.
2. `adlc-explore` - investigate options without committing to a plan.
3. `adlc-grounded` - answer from evidence only when guessing is unacceptable.
4. `adlc-architecture` - create or refresh architecture artifacts from repo evidence.
5. `adlc-roadmap` - maintain milestones and long-range sequencing.
6. `adlc-rules` - capture project rules and area conventions.
7. `adlc-reference` - create durable reference artifacts from sources.
8. `adlc-plan` - create fast or full implementation plans.
9. `adlc-improve` - tighten an existing plan before implementation.
10. `adlc-implement` - execute a plan with Codex coordinators, workers, and sidecars.
11. `adlc-verify` - prove completion against plan, rules, and repo behavior.
12. `adlc-rules-check` - run a standalone read-only rules gate.
13. `adlc-security-checklist` - run a standalone read-only security gate.
14. `adlc-review` - review diffs for correctness, maintainability, and risk.
15. `adlc-docs` - audit and update lifecycle documentation.
16. `adlc-qa` - create change summaries, test plans, and manual test cases.
17. `adlc-commit` - prepare conventional commits from staged work.
18. `adlc-fix` - diagnose, fix, and record a learning patch.
19. `adlc-loop` - run bounded iterative improvement loops.
20. `adlc-workstream` - plan grounded epic workstreams for Codex or Hermes handoff.
21. `adlc-evolve` - turn patches and repeated findings into durable rules or skill updates.

Broad Docker, CI, build automation, and skill-generator surfaces remain intentionally deferred until repeated use proves they need standalone ADLC commands.

The CLI is the public tooling surface:

```bash
node bin/adlc.js runtimes
node bin/adlc.js install /path/to/project --runtime codex-project
node bin/adlc.js status /path/to/project --runtime codex-project
node bin/adlc.js update /path/to/project --runtime codex-project
node bin/adlc.js upgrade
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

## Artifact Ownership

Default target-project paths:

```text
.adlc/
  config.yaml
  DESCRIPTION.md
  ARCHITECTURE.md
  ROADMAP.md
  RULES.md
  rules/
  RESEARCH.md
  PLAN.md
  plans/
  fixes/
  patches/
  references/
  skill-context/
  qa/
  loops/
  workstreams/
```

Ownership is strict:

- `adlc` owns setup context.
- `adlc-explore` owns research only when explicitly asked to persist it.
- `adlc-architecture` owns architecture artifacts.
- `adlc-roadmap` owns roadmap artifacts.
- `adlc-rules` owns base and area-specific rules.
- `adlc-reference` owns reference artifacts.
- `adlc-plan` owns plan files.
- `adlc-improve` may edit plan files.
- `adlc-implement` owns code changes for the selected plan tasks.
- `adlc-verify`, `adlc-rules-check`, `adlc-security-checklist`, `adlc-review`, and sidecars are read-only by default.
- `adlc-docs` owns documentation updates requested by the plan or gates.
- `adlc-qa` owns QA artifacts.
- `adlc-workstream` owns epic workstreams, step cards, Kanban state, and Codex/Hermes handoff exports.
- `adlc-fix` owns fix plans and patches.
- `adlc-loop` owns loop notes and iteration state.
- `adlc-evolve` owns skill-context and proposed ADLC updates.

## Codex Native Agents

Codex agents live in `subagents/codex/agents/`:

- `plan-coordinator`
- `plan-polisher`
- `implement-coordinator`
- `implement-worker`
- `review-sidecar`
- `security-sidecar`
- `rules-sidecar`
- `docs-auditor`
- `best-practices-sidecar`
- `commit-preparer`

The coordinator agents own orchestration. Worker agents own bounded edits. Sidecars are read-only unless their file says otherwise.

## Install For Local Codex

```bash
scripts/install-codex-adlc.sh
```

This syncs skills into `${CODEX_HOME:-~/.codex}/skills` and Codex agent TOML files into `${CODEX_HOME:-~/.codex}/agents`.

The same flow is available through the ADLC CLI:

```bash
node bin/adlc.js install-codex
```

`install-codex` records managed state in `${CODEX_HOME:-~/.codex}/adlc-managed-state.json` after a successful sync. Use these commands to inspect or refresh the local install:

```bash
node bin/adlc.js status
node bin/adlc.js status --strict --json
node bin/adlc.js update
node bin/adlc.js update --force
```

`update` stops before overwriting drifted managed artifacts unless `--force` is provided.

Project runtime installs are also supported:

```bash
node bin/adlc.js install /path/to/project --runtime codex-project
node bin/adlc.js install /path/to/project --runtime claude-project
```

The first supported runtimes are `codex-home`, `codex-project`, `claude-project`, and `universal-project`.

For `codex-project`, ADLC also installs and tracks the project-local `.codex/config.toml` from `subagents/codex/config.toml`. ADLC MCP blocks inside that file are ignored for managed-state hashing, so `mcp configure` can add servers without making the baseline Codex agent config look drifted.

## Initialize A Project

```bash
scripts/init-adlc-project.sh /path/to/project
```

This creates the `.adlc/` scaffold and preserves existing project context files.

The CLI equivalent is:

```bash
node bin/adlc.js init /path/to/project
```

Resolve the effective ADLC paths for a project with:

```bash
node bin/adlc.js resolve-config /path/to/project
node bin/adlc.js resolve-config /path/to/project --json
```

Create durable workstreams for epics that need staged Codex or Hermes execution:

```bash
node bin/adlc.js workstream create project-automation /path/to/project --executor either
node bin/adlc.js workstream status project-automation /path/to/project
node bin/adlc.js workstream advance project-automation 0001 /path/to/project --stage build
```

## MCP Auto-Config

ADLC includes local templates for `filesystem`, `github`, `postgres`, `playwright`, and `chrome-devtools`.

```bash
node bin/adlc.js mcp list
node bin/adlc.js mcp configure filesystem /path/to/project --runtime codex-project
node bin/adlc.js mcp remove filesystem /path/to/project --runtime codex-project
```

Codex runtimes write marked TOML blocks. Claude project runtime writes `.mcp.json`.

## Extensions

ADLC supports local extension packs with `extension.json`; the schema lives at [schemas/extension.schema.json](./schemas/extension.schema.json). Extension registry state is project-local under `.adlc/extensions/registry.json`.

```bash
node bin/adlc.js extension validate extensions/marketplace/hello-adlc
node bin/adlc.js extension add extensions/marketplace/hello-adlc /path/to/project --runtime codex-project
node bin/adlc.js extension list /path/to/project
node bin/adlc.js extension remove hello-adlc /path/to/project --runtime codex-project
```

## Package Status

The repo has private package metadata as `@davidvictor/adlc` and a local CLI at `bin/adlc.js`. It is intentionally not public on NPM yet; publish only when public distribution is simpler than private Git/GitHub installation.

## Factory Parity Plan

See [docs/factory-parity-gap-plan.md](./docs/factory-parity-gap-plan.md) for the active gap list, completed foundation work, and remaining deliberate limits.

## Artifact Audit

```bash
node bin/adlc.js audit-artifacts docs README.md AGENTS.md
node bin/adlc.js audit-artifacts --strict --json docs README.md AGENTS.md
```

The audit scans markdown frontmatter for ADLC artifact IDs, owners, status, type, duplicate IDs, and broken relations. It is intentionally lightweight now so plans, ADRs, QA notes, and reference docs can become traceable before the heavier managed-update system lands.

## Gate Results

Review, verify, and future read-only gates append a final `adlc-gate-result` fenced JSON block. The schema lives in [docs/gate-result-schema.md](./docs/gate-result-schema.md); orchestration should parse that final block instead of scraping prose.

## Validation

```bash
scripts/list-adlc.sh
scripts/validate-adlc.sh
node bin/adlc.js validate
```

Validation fails if old upstream-prefixed skill paths remain, if the plugin manifest points at removed skills, if required Codex agents are missing, if package metadata is unsafe to publish accidentally, or if the public docs drift from the ADLC command surface.

## Refactor Record

See [docs/ai-factory-port-audit.md](./docs/ai-factory-port-audit.md) for the AI Factory comparison, removal/adaptation decisions, and the concrete replacement path.
