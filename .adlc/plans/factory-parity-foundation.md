---
id: adlc-plan-factory-parity-foundation
type: implementation-plan
status: active
owner: ADLC
depends_on: [adlc-doc-factory-parity-gap-plan]
---

# Factory Parity Foundation Plan

Status: active

## Goal

Close the highest-impact gaps between ADLC and the original AI Factory architecture while keeping ADLC small, Codex-first, and specific to David's workflow.

## Tasks

1. Document the full missing surface. `done`
   - Owner: ADLC docs
   - Acceptance: `docs/factory-parity-gap-plan.md` names missing installer, MCP, extensions, managed state, artifact audit, and standalone lifecycle skills.
   - Verification: documentation is referenced from README and validation passes.

2. Add a CLI foundation. `done`
   - Owner: package tooling
   - Acceptance: `bin/adlc.js` supports `help`, `validate`, `list`, `install-codex`, `init`, and `audit-artifacts`.
   - Verification: CLI commands run locally without external dependencies.

3. Add artifact audit. `done`
   - Owner: package tooling
   - Acceptance: `adlc audit-artifacts` scans markdown artifacts, validates IDs, owners, relations, duplicates, and strict mode.
   - Verification: `node bin/adlc.js audit-artifacts docs README.md AGENTS.md` succeeds or reports actionable findings.

4. Define ADLC gate schema. `done`
   - Owner: lifecycle skills
   - Acceptance: docs describe the final `adlc-gate-result` block and review/verify skills use it.
   - Verification: validation checks skill text for schema fields.

5. Add managed install/update state. `done`
   - Owner: installer
   - Acceptance: install records source and installed hashes for managed Codex skills and agents, update reports drift before overwriting.
   - Verification: fixture or local dry run shows changed/unchanged/drifted states.

6. Add shared config/path resolver. `done`
   - Owner: tooling
   - Acceptance: CLI can print resolved ADLC paths for a target repo from `.adlc/config.yaml` plus defaults.
   - Verification: fixture config resolves plans, rules, QA, patches, and skill-context paths.

7. Restore standalone lifecycle skills. `done`
   - Owner: skills
   - Acceptance: add `adlc-roadmap`, `adlc-rules`, `adlc-rules-check`, `adlc-docs`, `adlc-qa`, `adlc-reference`, and `adlc-loop`.
   - Verification: validation includes the new public skill set and docs explain ownership.

8. Add CLI fixture verification. `done`
   - Owner: package tooling
   - Acceptance: a script exercises help, list, init, config resolution, artifact audit, managed status, and validation.
   - Verification: `bash scripts/test-adlc-cli.sh` passes.

9. Add runtime registry and multi-runtime install. `done`
   - Owner: package tooling
   - Acceptance: CLI supports `codex-home`, `codex-project`, `claude-project`, and `universal-project` runtime targets.
   - Verification: fixture installs into at least one project runtime.

10. Add MCP auto-config. `done`
    - Owner: package tooling
    - Acceptance: CLI lists, configures, and removes known MCP server templates for supported runtimes.
    - Verification: fixture configures and removes filesystem MCP in a temporary runtime.

11. Add local extension registry. `done`
    - Owner: package tooling
    - Acceptance: CLI validates, adds, lists, and removes a local extension pack with safe hash-based removal.
    - Verification: fixture installs and removes `extensions/marketplace/hello-adlc`.

12. Add ADLC-native documentation guides. `done`
    - Owner: docs
    - Acceptance: docs include ADLC versions of getting started, workflow, configuration, config reference, skills, subagents, quality gates, plan files, loop, evolve, extensions, security, runtimes, MCP, and artifact audit.
    - Verification: README links the guide set, validation requires the files, and artifact audit passes.

13. Track managed Codex project config. `done`
    - Owner: package tooling
    - Acceptance: `codex-project` installs and tracks `.codex/config.toml` while ignoring ADLC MCP blocks during drift checks.
    - Verification: CLI fixture installs project config, configures/removes MCP, and keeps `status --strict` green.

14. Port core support references, templates, and fixtures. `done`
    - Owner: skills
    - Acceptance: retained core skills include ADLC-native references/templates/tests for plan, implement, verify, loop, QA, reference, docs, and rules-check behavior.
    - Verification: `bash scripts/test-adlc-skill-fixtures.sh` passes.

15. Add architecture and security owners. `done`
    - Owner: skills
    - Acceptance: `adlc-architecture` owns architecture artifacts and `adlc-security-checklist` owns the standalone security gate.
    - Verification: validation includes 20 public skills and gate schema checks include security.

16. Harden local extensions. `done`
    - Owner: package tooling
    - Acceptance: local extensions support replacement skills, content injections, MCP setup/removal, and safe cleanup.
    - Verification: CLI fixture installs and removes the hello extension replacement, injection, custom skill, and MCP block.

## Commit Plan

1. `docs: map factory parity gaps`
2. `feat: add adlc cli and artifact audit`
3. `feat: standardize adlc gate results`
4. `feat: track managed codex install state`
5. `feat: resolve adlc config paths`
6. `feat: restore lifecycle skills`
