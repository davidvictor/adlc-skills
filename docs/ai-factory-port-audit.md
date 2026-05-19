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
- `skills/adlc/adlc-architecture`
- `skills/adlc/adlc-roadmap`
- `skills/adlc/adlc-rules`
- `skills/adlc/adlc-reference`
- `skills/adlc/adlc-plan`
- `skills/adlc/adlc-workstream`
- `skills/adlc/adlc-improve`
- `skills/adlc/adlc-implement`
- `skills/adlc/adlc-verify`
- `skills/adlc/adlc-rules-check`
- `skills/adlc/adlc-security-checklist`
- `skills/adlc/adlc-review`
- `skills/adlc/adlc-docs`
- `skills/adlc/adlc-qa`
- `skills/adlc/adlc-commit`
- `skills/adlc/adlc-fix`
- `skills/adlc/adlc-loop`
- `skills/adlc/adlc-evolve`
- `templates/adlc/config.yaml`
- `subagents/codex/agents/*.toml`
- `scripts/install-codex-adlc.sh`
- `scripts/init-adlc-project.sh`
- `scripts/list-adlc.sh`
- `scripts/validate-adlc.sh`
- `scripts/test-adlc-cli.sh`
- `scripts/test-adlc-skill-fixtures.sh`
- `bin/adlc.js`
- `mcp/templates/*.json`
- `schemas/extension.schema.json`
- `extensions/marketplace/hello-adlc`

Agent model:

- Ported `plan-coordinator`, `plan-polisher`, `implement-coordinator`, `implement-worker`, `review-sidecar`, `security-sidecar`, `docs-auditor`, `best-practices-sidecar`, and `commit-preparer`.
- Added `rules-sidecar` because AI Factory documents it in the quality-sidecar family, while the Codex bundle snapshot did not include a TOML file for it.
- Kept sidecars read-only so implementation writes stay owned by `implement-coordinator` and `implement-worker`.

Workflow:

- Ported setup -> explore/grounded -> plan -> optional workstream -> improve -> implement -> verify -> review -> commit -> evolve.
- Kept bug work as `adlc-fix` feeding verification, review, commit, and evolve.
- Kept strict handoff through artifacts rather than external Kanban state.

## Not Ported

CLI and distribution:

- AI Factory is an NPM package with a TypeScript CLI, `ai-factory init`, `update`, `upgrade`, extension commands, artifact auditing, and managed install metadata.
- ADLC now has a dependency-light Node CLI with `init`, `validate`, `install`, `update`, `upgrade`, `audit-artifacts`, runtime, MCP, and extension commands.
- ADLC is private in `package.json`; it is not ready for NPM publication.

Multi-runtime support:

- AI Factory supports Claude, Cursor, Windsurf, Roo, Kilo, Antigravity, OpenCode, Warp, Zencoder, Codex CLI, Codex app, Copilot, Gemini, Junie, Qwen, and universal agents.
- ADLC supports `codex-home`, `codex-project`, `claude-project`, and `universal-project` runtime targets. Codex runtimes install native agent TOMLs; non-Codex runtimes install skills only.

MCP and extension system:

- AI Factory configures supported MCP servers and supports extension manifests, extension skill replacement, extension agent files, and injection blocks.
- ADLC now has MCP auto-config for known local templates and local extension add/list/remove/validate behavior.
- Local ADLC extensions support custom skills, replacement skills, injection blocks, agent files, and MCP server install/removal.
- ADLC still does not support remote extension fetching, dynamic extension CLI commands, extension-defined runtime registration, or extension update checks.

Additional upstream skills:

- Restored as ADLC public commands after the parity audit: roadmap, rules, rules-check, docs, QA, reference, and loop.
- Added after the follow-up audit: architecture and security-checklist.
- Still not ported as public commands: best-practices, build-automation, CI, dockerize, and skill-generator.
- Their useful responsibilities are either folded into the core commands, handled by sidecars, or deferred until repeated local usage proves the need.

Artifact management:

- AI Factory has artifact metadata and an `audit-artifacts` CLI.
- ADLC now has `node bin/adlc.js audit-artifacts` with strict checks for IDs, duplicate IDs, owners, status, type, and broken relations.

## Current Blockers

- Managed install state exists for packaged skills, Codex agents, and `codex-project` runtime config, including changed/unchanged/missing/drift/source-changed and safe removal of removed package artifacts.
- ADLC-owned MCP blocks in `.codex/config.toml` are normalized out of managed config hashes.
- `node bin/adlc.js update` is the ADLC update entrypoint. Package self-update is guidance-only while ADLC remains private.
- No true init wizard: `init-adlc-project.sh` scaffolds `.adlc/`, but it does not infer project language, branch policy, or artifact paths.
- Config-aware path resolution is started as `node bin/adlc.js resolve-config`, and every public skill now instructs agents to resolve configured paths before using ADLC artifacts.
- Artifact audit is started as `node bin/adlc.js audit-artifacts`, but artifact schema adoption across all future plans, ADRs, specs, rules, and QA artifacts remains a process requirement.
- CLI fixture tests cover help, list, init, config resolution, runtime install, managed Codex config, MCP configure/remove, extension replacement/injection/MCP cleanup, managed status, artifact audit, and validation.
- Skill fixture tests cover ADLC-native references, templates, and YAML fixtures for the core retained skills.
- No package publication decision has been executed.

## Package Decision

ADLC should not publish a public NPM package yet.

Current state supports a private package scaffold:

- `package.json` names the package `@davidvictor/adlc`.
- `private: true` prevents accidental publication.
- NPM scripts wrap the local CLI and compatibility shell commands.
- No runtime dependencies are needed yet.

Publish later only when ADLC has:

- repeated successful use on real repos
- a stable decision that public distribution is better than private Git/GitHub install
- a stable cross-machine install contract

Until then, the repo-local installer is simpler, clearer, and less brittle for David's workflow.

## Initialization Direction

Current setup:

- `scripts/init-adlc-project.sh [target]` creates `.adlc/`, copies `templates/adlc/config.yaml`, and creates missing `DESCRIPTION.md`, `ARCHITECTURE.md`, and `RULES.md`.
- The `adlc` skill remains the agent-native setup command for context analysis and refinement.

Next setup target:

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
- Architecture and security now have explicit skill owners rather than being implicit review concerns.
- Local extension replacement, injection, and MCP cleanup are fixture-tested.

What remains incomplete:

- The CLI covers local lifecycle management, but the package is still not public-distribution ready.
- Skills describe workflows and now route agents through config resolution, but they do not programmatically consume a shared library inside agent execution.
- Gate JSON contracts exist in skills and validation checks required schema fields.
- Sidecar roles are installed, but orchestration still depends on the main agent choosing to delegate correctly.
- There is no migration tool for target repos that already have older `docs/adlc` or `.scratch/adlc-*` artifacts.
- Extension-defined runtime registration and dynamic CLI command loading remain deferred.

## Next Steps

1. Exercise the new ADLC flow on one real repo task and record the friction.
2. Add live-output fixture tests for `adlc-plan`, `adlc-implement`, `adlc-verify`, `adlc-security-checklist`, and `adlc-review` contracts after real runs accumulate.
3. Add branch/base-branch inference to `resolve-config`.
4. Add extension-defined runtime registration only when a real local extension needs it.
5. Revisit NPM publication only after several successful private-repo installs.
