---
id: adlc-doc-factory-parity-gap-plan
type: parity-plan
status: active
owner: ADLC
---

# ADLC Factory Parity Gap Plan

Status: active

This document is the source of truth for turning the current lean ADLC fork into David's own AI Factory-style lifecycle system. It records what was not ported, why it matters, and the order for closing the gaps without rebuilding broad upstream surface area we do not use.

## Current State

ADLC currently has:

- twenty-one public skills under `skills/adlc/`
- Codex-native agent TOMLs under `subagents/codex/agents/`
- a dependency-light Node CLI at `bin/adlc.js`
- target-project scaffolding through `scripts/init-adlc-project.sh`
- runtime install, update, status, MCP, extension, artifact audit, and config-resolution commands
- managed project Codex config install/update state for `codex-project`
- ADLC-native guides under `docs/`
- package validation through `scripts/validate-adlc.sh`
- documentation that names ADLC as a lean fork rather than AI Factory compatibility

This now covers the useful AI Factory-style backbone for ADLC. Remaining gaps are deliberate limits or hardening targets rather than absent foundation.

## Missing Aspects

### P0: CLI Foundation

Missing:

- TypeScript packaging and generated `dist/` output
- published package entrypoint

Divergence:

- AI Factory exposes a TypeScript CLI package with `ai-factory` commands.
- ADLC exposes a dependency-light Node CLI plus compatibility shell scripts.

Impact:

- Local operation is covered.
- Public package distribution is still intentionally deferred.

Direction:

- Add a dependency-light Node CLI first.
- Keep shell scripts as implementation helpers while the CLI stabilizes.
- Move logic into shared modules only after command behavior repeats.

Progress:

- Added `bin/adlc.js` with lifecycle, runtime, MCP, extension, audit, config, validation, and update commands.

### P0: Managed Install And Update State

Missing:

- package self-update from an external registry

Divergence:

- AI Factory records managed skill, agent, config, MCP, and extension state in `.ai-factory.json`.
- ADLC rsyncs into Codex home and copies agent files without state.

Impact:

- Skill and agent drift is now visible before update.
- Missing packaged files are separated from intentionally removed package artifacts.
- Project Codex config drift is visible while ADLC-owned MCP blocks are normalized out of managed hashes.

Direction:

- Start with repo-local install state for Codex only.
- Track hashes for installed ADLC skills and Codex agent TOMLs.
- Add force mode only after ordinary drift reporting is safe.

Progress:

- Started with `node bin/adlc.js status`, `node bin/adlc.js install-codex`, and `node bin/adlc.js update`.
- Managed state is recorded at `${CODEX_HOME:-~/.codex}/adlc-managed-state.json` after install.
- Update stops on drift unless `--force` is supplied.
- Project runtime managed state is recorded under `.adlc/managed-state.<runtime>.json`.
- Removed package artifacts are deleted only when their installed hash still matches the recorded managed hash.
- `codex-project` installs and tracks `.codex/config.toml` from `subagents/codex/config.toml`.
- ADLC-owned MCP blocks in `.codex/config.toml` are ignored during managed config hashing.

### P0: Gate Result Contract

Missing:

- broader fixture validation of actual gate outputs from live agent responses

Divergence:

- AI Factory gates append a final parseable gate-result block.
- ADLC review and verify use reduced JSON shapes.

Impact:

- Future orchestration cannot reliably parse gate status.
- Sidecars and coordinators may disagree about what blocks progress.

Direction:

- Define an ADLC-owned gate schema in docs.
- Update `adlc-verify`, `adlc-review`, and future `adlc-rules-check`.
- Add fixture tests that fail on schema drift.

Progress:

- Added `docs/gate-result-schema.md`.
- Updated `adlc-verify`, `adlc-review`, `adlc-rules-check`, and `adlc-security-checklist` to use `adlc-gate-result`.
- Validation checks required schema fields in gate skill output contracts.

### P1: Artifact Audit CLI

Missing:

- full adoption of artifact frontmatter across every future plan, QA artifact, and reference

Divergence:

- AI Factory includes an `audit-artifacts` CLI that scans markdown artifacts and validates relationships.
- ADLC now has ownership guidance and an executable audit.

Impact:

- New tracked artifacts can be checked for IDs, owners, status, type, duplicates, and broken relations.
- Existing untracked docs remain readable without forcing metadata everywhere at once.

Direction:

- Port the useful markdown artifact audit behavior into the ADLC CLI.
- Default scan targets should be `.adlc`, `docs`, `README.md`, and `AGENTS.md`.
- Keep the schema small and ADLC-specific.

Progress:

- Added `node bin/adlc.js audit-artifacts`.
- Strict mode checks IDs, duplicate IDs, owner/status/type, broken relations, and project-boundary safety.

### P1: Config Resolver

Missing:

- deeper nested YAML support
- branch/base-branch detection
- config-preserving update behavior
- rules hierarchy resolution

Divergence:

- AI Factory has config loading, update helpers, and documented writer rules.
- ADLC skills hardcode `.adlc/` path assumptions.

Impact:

- Path overrides in `templates/adlc/config.yaml` are guidance, not consistently enforceable behavior.
- Skills can diverge in how they interpret plans, rules, QA, patches, and research paths.

Direction:

- Build a tiny config reader before adding more skills.
- Avoid external YAML dependencies at first by supporting the current simple template shape.
- Add tests around path resolution.

Progress:

- Started with `node bin/adlc.js resolve-config [target-dir]`.
- The command merges template defaults with target `.adlc/config.yaml` when present and prints relative plus absolute paths.
- All public skills now instruct agents to resolve effective ADLC paths before using configured artifacts.

### P1: Standalone Lifecycle Skills

Restored standalone skills:

- `adlc-roadmap`
- `adlc-rules`
- `adlc-rules-check`
- `adlc-docs`
- `adlc-qa`
- `adlc-reference`
- `adlc-loop`
- `adlc-architecture`
- `adlc-security-checklist`
- `adlc-workstream`

Deferred or likely unnecessary:

- `adlc-dockerize`
- `adlc-ci`
- `adlc-build-automation`
- `adlc-skill-generator`
- broad `adlc-best-practices`

Divergence:

- AI Factory ships these as separate public skills.
- ADLC folded some responsibilities into core skills or omitted them.

Impact:

- Public lifecycle artifact ownership is now explicit.
- Review and verify no longer absorb architecture, security, QA, docs, or rules ownership by default.

Direction:

- Add only the lifecycle skills that map to David's workflow.
- Keep build, CI, Docker, skill generator, and broad best-practices command surfaces out until repeated use proves they deserve standalone commands.

Progress:

- Restored `adlc-roadmap`, `adlc-rules`, `adlc-rules-check`, `adlc-docs`, `adlc-qa`, `adlc-reference`, and `adlc-loop` as standalone lifecycle skills.
- Added `adlc-architecture` as the owner of architecture artifacts.
- Added `adlc-security-checklist` as the standalone security gate.
- Added `adlc-workstream` as the owner of long-running epic step cards and Codex/Hermes handoffs.
- Updated the default config paths and project init scaffold for roadmap, rules, references, QA, and loop artifacts.

### P2: Multi-Runtime Installer

Missing:

- broad upstream runtime coverage
- extension-provided runtime definitions
- runtime target conflict detection beyond known ADLC paths

Divergence:

- AI Factory supports many agents and extensions can add more.
- ADLC targets Codex home only.

Impact:

- ADLC cannot serve as a portable agent lifecycle package.
- Cross-runtime consistency must be handled manually.

Direction:

- Keep the registry lean and add runtimes only when David uses them.
- Do not port broad runtime support speculatively.

Progress:

- Added a lean runtime registry with `codex-home`, `codex-project`, `claude-project`, and `universal-project`.
- `node bin/adlc.js install/status/update --runtime <id>` now operates against selected runtime targets.

### P2: MCP Auto-Config

Missing:

- managed hash tracking for generated MCP config blocks
- richer validation for runtime-specific MCP schema quirks

Divergence:

- AI Factory writes MCP settings for supported runtimes.
- ADLC has a lean MCP setup surface for known templates.

Impact:

- Tooling setup remains manual and inconsistent across repos.

Direction:

- Add only Codex app/Codex CLI MCP configuration after runtime state exists.
- Start with read-only reporting before mutating user settings files.

Progress:

- Added MCP templates for `filesystem`, `github`, `postgres`, `playwright`, and `chrome-devtools`.
- Added `node bin/adlc.js mcp list|configure|remove`.
- Codex runtimes write marked TOML blocks; Claude project runtime writes `.mcp.json`.

### P2: Extensions And Marketplace

Missing:

- remote extension fetching/version checks
- dynamic extension CLI command loading
- extension-defined runtime registration

Divergence:

- AI Factory treats extensions as first-class.
- ADLC now supports local extension packs for customization.

Impact:

- Custom workflows can bloat the ADLC core.
- There is no clean lane for optional workflow packs.

Direction:

- Keep extensions local-first until remote installation is needed.
- Keep replacement and injection behavior local, explicit, and fixture-tested before adding remote sources.

Progress:

- Added a local extension schema, registry, and sample marketplace fixture under `extensions/marketplace/hello-adlc`.
- Added `node bin/adlc.js extension list|validate|add|remove`.
- Extension removal uses installed hashes and skips drifted files unless `--force` is supplied.
- Local extensions can install custom skills, replace packaged ADLC skills, inject marked content into installed skills, add agent files, and configure/remove MCP servers.
- Removal strips injections, removes extension MCP keys, and restores replaced packaged skills when safe.

## Priority Roadmap

1. Keep hardening CLI fixtures around real ADLC use.
2. Add branch/base-branch inference to `resolve-config`.
3. Add remote extension/version checks only after local extensions are used in real projects.
4. Add dynamic extension commands and runtime definitions only when a real ADLC pack needs them.
5. Revisit public NPM publication after the private CLI survives several repo tasks.

## Documentation Parity

ADLC now has its own guide set rather than relying on AI Factory docs:

- getting started
- workflow
- configuration and config reference
- skills and subagents
- quality gates and plan files
- loop and evolve
- runtimes, MCP, and extensions
- artifact audit and security

## Completion Criteria

ADLC is complete enough for this phase when:

- `adlc validate` passes.
- `adlc audit-artifacts --strict` can gate this repo.
- review and verify skills emit the same ADLC gate schema.
- target repo init writes context that every lifecycle skill can resolve.
- install/update can report local drift without overwriting it silently.
- every public lifecycle artifact has a clear owning skill.
- omitted AI Factory features are documented as explicit ADLC decisions, not accidental gaps.
