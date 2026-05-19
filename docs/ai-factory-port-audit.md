# AI Factory Port Audit

## Upstream Reviewed

Reviewed against `lee-to/ai-factory` branch `2.x`, with emphasis on:

- `docs/getting-started.md`
- `docs/workflow.md`
- `docs/subagents.md`
- `docs/config-reference.md`
- `docs/plan-files.md`
- `docs/quality-gates.md`
- `package.json`
- `src/cli/commands/init.ts`
- `src/core/agents.ts`
- `src/core/config.ts`
- `src/core/installer.ts`
- `skills/aif*/`
- `subagents/codex/`

## Factory Concepts As Interpreted For ADLC

ADLC ports the architecture, not the brand or broad distribution surface.

- Command pipeline: fewer public commands, each with a clear lifecycle role.
- Artifact ownership: every writable artifact has one owning command.
- Project context root: target repos use `.adlc/` as the shared context directory.
- Planning contract: `adlc-plan` produces executable plans; `adlc-improve` refines them; `adlc-implement` executes them.
- Native agents: coordinators orchestrate, workers edit bounded scopes, sidecars stay read-only.
- Gates: verification and review produce human summaries plus machine-readable result blocks.
- Learning loop: fixes create patches; evolve converts repeated learning into project rules or ADLC source changes.

## Ported Into ADLC

Structure:

- `skills/adlc/adlc`
- `skills/adlc/adlc-explore`
- `skills/adlc/adlc-grounded`
- `skills/adlc/adlc-plan`
- `skills/adlc/adlc-improve`
- `skills/adlc/adlc-implement`
- `skills/adlc/adlc-verify`
- `skills/adlc/adlc-review`
- `skills/adlc/adlc-commit`
- `skills/adlc/adlc-fix`
- `skills/adlc/adlc-evolve`
- `templates/adlc/config.yaml`
- `subagents/codex/agents/*.toml`
- `scripts/install-codex-adlc.sh`
- `scripts/init-adlc-project.sh`
- `scripts/list-adlc.sh`
- `scripts/validate-adlc.sh`

Agent model:

- Ported `plan-coordinator`, `plan-polisher`, `implement-coordinator`, `implement-worker`, `review-sidecar`, `security-sidecar`, `docs-auditor`, `best-practices-sidecar`, and `commit-preparer`.
- Added `rules-sidecar` because AI Factory documents it in the quality-sidecar family, while the Codex bundle snapshot did not include a TOML file for it.
- Kept sidecars read-only so implementation writes stay owned by `implement-coordinator` and `implement-worker`.

Workflow:

- Ported setup -> explore/grounded -> plan -> improve -> implement -> verify -> review -> commit -> evolve.
- Kept bug work as `adlc-fix` feeding verification, review, commit, and evolve.
- Kept strict handoff through artifacts rather than external Kanban state.

## Not Ported

CLI and distribution:

- AI Factory is an NPM package with a TypeScript CLI, `ai-factory init`, `update`, `upgrade`, extension commands, artifact auditing, and managed install metadata.
- ADLC currently has shell scripts and package metadata, but no built TypeScript CLI.
- ADLC is private in `package.json`; it is not ready for NPM publication.

Multi-runtime support:

- AI Factory supports Claude, Cursor, Windsurf, Roo, Kilo, Antigravity, OpenCode, Warp, Zencoder, Codex CLI, Codex app, Copilot, Gemini, Junie, Qwen, and universal agents.
- ADLC currently targets local Codex skills and Codex native agents only.

MCP and extension system:

- AI Factory configures supported MCP servers and supports extension manifests, extension skill replacement, extension agent files, and injection blocks.
- ADLC has no MCP auto-config, extension registry, or replacement/injection machinery.

Additional upstream skills:

- Not ported as public commands: architecture, roadmap, rules, rules-check, docs, QA, reference, best-practices, build-automation, CI, dockerize, security-checklist, skill-generator, and loop.
- Their useful responsibilities are either folded into the core commands or deferred until repeated local usage proves the need.

Artifact management:

- AI Factory has artifact metadata and an `audit-artifacts` CLI.
- ADLC has artifact ownership guidance but no metadata schema enforcement yet.

## Current Blockers

- No managed install state: `install-codex-adlc.sh` syncs files but does not track hashes, changed/unchanged status, or safe removal with metadata.
- No update command: there is no single `adlc update` equivalent.
- No true init wizard: `init-adlc-project.sh` scaffolds `.adlc/`, but it does not infer project language, branch policy, or artifact paths.
- No config-aware path resolver shared by skills: skills reference `.adlc/` defaults directly.
- No artifact audit command: plans, ADRs, specs, rules, and QA artifacts do not yet have traceable IDs or relationship checks.
- No end-to-end fixture tests for skill behavior.
- No package publication decision has been executed.

## Package Decision

ADLC should not publish a public NPM package yet.

Current state supports a private package scaffold:

- `package.json` names the package `@davidvictor/adlc`.
- `private: true` prevents accidental publication.
- NPM scripts wrap the local shell commands.
- No runtime dependencies are needed yet.

Publish later only when ADLC has:

- a real CLI entrypoint
- managed install/update state
- project init/update commands
- fixture-backed tests
- a stable cross-machine install contract

Until then, the repo-local installer is simpler, clearer, and less brittle for David's workflow.

## Initialization Direction

Current setup:

- `scripts/init-adlc-project.sh [target]` creates `.adlc/`, copies `templates/adlc/config.yaml`, and creates missing `DESCRIPTION.md`, `ARCHITECTURE.md`, and `RULES.md`.
- The `adlc` skill remains the agent-native setup command for context analysis and refinement.

Next setup target:

- Add a config-aware helper that can read `.adlc/config.yaml`.
- Preserve user edits on rerun.
- Derive `git.base_branch` and `git.create_branches` from repo policy.
- Allow repo-local overrides without changing the shared ADLC package.

## Robustness Audit

What is robust now:

- Public command surface is small and ADLC-named.
- Local Codex install and repo validation are automated.
- Native Codex agents are package artifacts.
- Old Hermes runner surface is removed.
- `.adlc/` provides a single project context root.
- Validation checks skill names, metadata, manifest entries, required agents, package privacy, and installer replacement behavior.

What remains incomplete:

- Shell scripts are enough for local sync but not enough for distributed lifecycle management.
- Skills describe workflows but do not share a code-level config parser.
- Gate JSON contracts exist in skills but are not validated by tests.
- Sidecar roles are installed, but orchestration still depends on the main agent choosing to delegate correctly.
- There is no migration tool for target repos that already have older `docs/adlc` or `.scratch/adlc-*` artifacts.

## Next Steps

1. Exercise the new ADLC flow on one real repo task and record the friction.
2. Add fixture tests for `adlc-plan`, `adlc-implement`, `adlc-verify`, and `adlc-review` contracts.
3. Add a small config/path resolver script before building a TypeScript CLI.
4. Add artifact metadata guidance and an audit script once plans and ADRs start accumulating.
5. Decide whether ADLC should stay Codex-only or support a second runtime.
6. Revisit NPM publication only after update/install state exists.
