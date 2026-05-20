---
id: adlc-plan-public-installability
type: plan
status: active
owner: ADLC
created: 2026-05-20
---

# Public Installability Plan

## Verdict

ADLC is visible as a public GitHub repository and now has a public-package install surface implemented locally.

The remaining external step is publishing `adlc-cli` to npm. Local tarball smoke tests now prove install, init, status, Hermes sync, audit, and uninstall from the packed package.

## Evidence

- `gh repo view davidvictor/adlc-skills --json visibility,url,isPrivate` returned `visibility=PUBLIC` and `isPrivate=false`.
- `package.json` uses `name=@davidvictor/adlc`, `version=0.1.0`, and `private=true`.
- `npm view adlc name version dist-tags.latest repository.url --json` returned `adlc@3.7.2` from `github.com/1xOps/adlc-framework.git`, so the unscoped `adlc` registry name is occupied.
- `npm view @davidvictor/adlc name version --json` returned `E404`, so the current scoped name has not been published.
- `README.md` still says the package is private and should publish only when public distribution is simpler than Git/GitHub installation.
- `scripts/validate-adlc.sh` fails unless the package remains `@davidvictor/adlc` and `private=true`.
- `bin/adlc.js upgrade` prints private-package guidance and tells users to update by `git pull`.
- There is no `.github/workflows/` directory, so public validation, packaging, and publishing are not automated.
- `npm --cache /private/tmp/adlc-npm-cache pack --dry-run --json` succeeds and packages 137 files, which means the package can be packed locally once npm cache permissions are controlled.
- The published tarball candidate currently includes historical/internal docs such as `docs/ai-factory-port-audit.md` and `docs/factory-parity-gap-plan.md`, plus docs with individual-specific wording. That content needs a public-docs pass before release.

## Distribution Decision

Publish the package as `adlc-cli` and keep the installed binary command as `adlc`.

Public usage should look like this:

```bash
npm install -g adlc-cli
cd /path/to/project
adlc init --agents codex,claude,hermes --mcp github,playwright
adlc status --strict
```

Non-interactive setup should also work:

```bash
npx adlc-cli init /path/to/project --agents codex,claude,hermes --mcp github,playwright
npx adlc-cli update /path/to/project
npx adlc-cli audit-artifacts /path/to/project/.adlc --strict
```

Keep Git clone setup as a contributor/development path, not as the public installation model.

## Installer Model

Follow the same shape as AI Factory:

- The user runs one `init` command.
- `init` accepts `--agents` to select supported agent targets.
- `init` accepts `--mcp` to configure known MCP servers during setup.
- The installer writes skills, agent files, config, and managed state to the selected agents' expected directories.
- `update` refreshes installed managed files for all selected agents.
- `status --strict` checks managed state, drift, missing files, and source changes.
- `extension add/list/update/remove` continues to work across selected agents.
- `upgrade` is reserved for package/schema migrations, not normal install or update.

Do not keep `install-codex` as a public command. Remove it from help, docs, scripts, tests, and validation during the installer rewrite.

## Agent Targets

Support exactly three agent targets for the first public release:

### Codex

Target id: `codex`

Installs:

- ADLC skills into `.codex/skills/`
- Codex native agent TOMLs into `.codex/agents/`
- managed Codex config into `.codex/config.toml`
- selected MCP blocks into `.codex/config.toml`
- managed state under `.adlc/managed-state.json`

Codex is the primary execution target for build, review, test, and commit handoffs.

### Claude

Target id: `claude`

Installs:

- ADLC skills into `.claude/skills/`
- Claude agent files into `.claude/agents/` when ADLC owns real Claude agent definitions
- selected MCP config into `.mcp.json`
- managed state under `.adlc/managed-state.json`

Claude support should be first-class for skills and MCP. Claude agent definitions should ship only when they are intentionally authored, not mechanically converted.

### Hermes

Target id: `hermes`

Installs:

- Hermes config into `.hermes/config.yaml`
- Hermes Kanban state into `.hermes/kanban.json`
- Hermes workstream cards into `.hermes/workstreams/`
- Hermes inbox handoffs into `.hermes/inbox/`
- ADLC workstream templates that can be handed to either Codex or Hermes
- managed state under `.adlc/managed-state.json`

Hermes is a managed workstream target. It does not need to mirror generic skill installation unless Hermes later consumes skills directly. Its first job is to receive ADLC-grounded epics as independent build/review/test/commit cards and maintain board state for long-running execution.

## Command Shape

Primary commands:

```bash
adlc init [target-dir] --agents codex,claude,hermes --mcp github,playwright
adlc update [target-dir]
adlc status [target-dir] --strict
adlc doctor [target-dir]
adlc uninstall [target-dir] --agents codex,claude,hermes
adlc audit-artifacts [targets...] --strict
adlc extension add <source> [target-dir]
adlc extension list [target-dir]
adlc extension update [target-dir]
adlc extension remove <name> [target-dir]
```

Remove or replace:

- remove `install-codex`
- replace `runtimes` with `agents`
- replace `install --runtime <id>` with `init --agents <ids>` and `update`
- replace runtime-specific managed-state files with one project managed-state file keyed by agent target

## Work Plan

### 1. Package Identity And Release Policy

Status: completed.

Actions:

- Rename package metadata to `adlc-cli`.
- Keep the binary command as `adlc`.
- Replace individual-specific package description with a project description.
- Remove `private=true` only when publish gates exist in CI.
- Add `repository`, `homepage`, `bugs`, `keywords`, `engines`, and `packageManager` metadata.
- Keep `license=MIT`.
- Add a short release policy covering semver, prereleases, and supported install paths.

Acceptance:

- `node -e` package metadata checks pass.
- Validation no longer enforces private-only package metadata.
- Validation enforces `adlc-cli`, the `adlc` bin, and release-safe fields.

### 2. Agent Installer Architecture

Status: completed.

Actions:

- Replace `runtimeRegistry` with an `agentRegistry`.
- Model each agent as an adapter with paths, files, MCP behavior, and managed-state behavior.
- Add `adlc agents` to list supported targets.
- Rewrite `init` to accept `--agents`, `--mcp`, `--skills`, and `--no-skills`.
- Make `update`, `status`, `doctor`, `uninstall`, and extensions operate across selected agents from project config.
- Store selected agents and MCP servers in `.adlc/config.yaml`.
- Store managed file hashes in one `.adlc/managed-state.json`.

Acceptance:

- `adlc init --agents codex,claude,hermes --mcp github,playwright` installs all selected targets.
- `adlc status --strict` reports all selected targets.
- `adlc update` refreshes all selected targets.
- Managed-state output clearly identifies agent, artifact type, source, destination, hash, and drift status.

### 3. Codex Adapter

Status: completed.

Actions:

- Install ADLC skills to `.codex/skills/`.
- Install Codex agent TOMLs to `.codex/agents/`.
- Install managed `.codex/config.toml`.
- Configure selected MCP servers with marked TOML blocks.
- Preserve existing non-ADLC project config.
- Remove home-only Codex installation from the public flow.

Acceptance:

- Codex project install works from a packed tarball.
- Codex managed config can be updated without treating MCP blocks as drift.
- Codex agent files are hash-tracked and safely removable by `uninstall`.

### 4. Claude Adapter

Status: completed.

Actions:

- Install ADLC skills to `.claude/skills/`.
- Install Claude agent definitions to `.claude/agents/` only after those definitions exist in the ADLC package.
- Configure selected MCP servers through `.mcp.json`.
- Preserve existing `.claude/` and `.mcp.json` content outside managed blocks.

Acceptance:

- Claude skill install works from a packed tarball.
- Claude MCP config is reversible by `uninstall`.
- Missing Claude agent definitions are represented as unsupported until real definitions are authored.

### 5. Hermes Adapter

Status: completed.

Actions:

- Define `.hermes/config.yaml`.
- Define `.hermes/kanban.json` with lanes for planned, build, review, test, commit, blocked, and done.
- Define `.hermes/workstreams/<slug>/steps/<step-id>.md` as executable cards.
- Define `.hermes/inbox/<workstream-slug>.md` as the Hermes handoff surface.
- Connect `adlc workstream create` to optional Hermes projection.
- Add `adlc workstream sync --agent hermes` to refresh Hermes cards from ADLC workstream state.

Acceptance:

- Hermes install creates an empty but valid board.
- Workstream sync creates independent step cards with build/review/test/commit lifecycle metadata.
- Hermes cards retain links back to source ADLC plan and workstream artifacts.

### 6. Command Pruning And Migration

Status: completed.

Actions:

- Remove `install-codex` from CLI help and command dispatch.
- Remove `scripts/install-codex-adlc.sh` after the Codex adapter covers project setup.
- Remove docs that instruct users to run `install-codex`.
- Replace runtime docs with agent-target docs.
- Update validation and tests to reject old public install commands.

Acceptance:

- `rg -n "install-codex|--runtime|codex-home|codex-project|claude-project|universal-project" README.md docs bin scripts package.json` returns zero public-command references, except archived historical notes outside the packaged docs allowlist.
- `adlc help` presents the agent-based command model only.

### 7. Public Docs Pass

Status: completed.

Actions:

- Update `README.md` with `npm install -g adlc-cli`, `adlc init --agents ...`, update, status, doctor, uninstall, and extension flows.
- Update `docs/getting-started.md`, `docs/agents.md`, `docs/configuration.md`, and `docs/README.md`.
- Move runtime docs to an archive or replace them with agent-target docs.
- Move historical parity/audit docs to an archive docs section or remove them from the npm `files` allowlist.
- Remove individual-specific wording from public docs.
- Add a support boundary: Codex, Claude, Hermes only for the first public release.

Acceptance:

- Public docs have one canonical setup path.
- Historical/internal docs are not packaged as primary public documentation.
- `rg -n "David|Victor|Factory|factory|lee-to|upstream|@davidvictor" README.md docs package.json bin scripts` returns only intentional archive hits or zero hits for packaged docs.

### 8. Pack And Install Smoke Tests

Status: completed.

Actions:

- Add a test script that runs `npm pack --dry-run`.
- Add a temp-directory smoke test:
  - create package tarball
  - install into an isolated temp project
  - run `adlc --help`
  - run `adlc agents`
  - run `adlc init <temp-project> --agents codex,claude,hermes --mcp filesystem`
  - run `adlc status <temp-project> --strict`
  - run `adlc workstream create <slug> <temp-project> --executor either`
  - run `adlc workstream sync <slug> <temp-project> --agent hermes`
  - run `adlc audit-artifacts --strict <temp-project>/.adlc`
  - run `adlc uninstall <temp-project> --agents codex,claude,hermes`
- Use a temp npm cache in tests so machine-local cache permissions do not affect results.

Acceptance:

- The smoke test passes on a clean machine and in CI.
- The packed file list contains only intended public assets.
- The smoke test proves the package from a tarball, not from the repo checkout.

### 9. CI Build Automation

Status: completed.

Actions:

- Add `.github/workflows/ci.yml`.
- Run validation on pull requests and main:
  - `npm run validate`
  - `npm run test:cli`
  - `npm run test:skill-fixtures`
  - package smoke test
  - artifact audit in strict mode
- Add Node matrix for supported Node versions.
- Upload the packed tarball as a CI artifact for release candidates.

Acceptance:

- Main cannot drift away from public installability without CI failing.
- CI exercises Codex, Claude, and Hermes install paths.

### 10. Release Automation

Status: completed locally; blocked on npm release credentials for actual publish.

Actions:

- Add a manual release workflow that runs CI, packs the package, and publishes `adlc-cli` to npm with provenance if available.
- Require npm token configuration through GitHub Actions secrets or trusted publishing.
- Create GitHub releases from tags.
- Publish prerelease versions first, such as `0.1.0-beta.1`.

Acceptance:

- A maintainer can publish by selecting a version/tag after CI passes.
- Release notes include install, update, uninstall, and rollback instructions.

### 11. Post-Release Verification

Status: blocked by first npm prerelease.

Actions:

- From a clean temp environment, run:
  - `npm install -g adlc-cli@beta`
  - `adlc init <temp-project> --agents codex,claude,hermes --mcp filesystem`
  - `adlc status <temp-project> --strict`
  - `npx adlc-cli@beta init <temp-project-2> --agents codex,hermes`
  - `adlc workstream create <slug> <temp-project> --executor either`
  - `adlc workstream sync <slug> <temp-project> --agent hermes`
  - `adlc uninstall <temp-project> --agents codex,claude,hermes`
- Confirm installed skills, agent files, MCP config, Hermes board files, and workstream cards match managed hashes.

Acceptance:

- Public install, update, workstream handoff, and cleanup work without source checkout access.

## Recommended Commit Sequence

1. `chore: prepare package identity for public install`
2. `refactor: replace runtime installs with agent targets`
3. `feat: add codex claude hermes installers`
4. `feat: add hermes workstream projection`
5. `docs: add public agent installation guide`
6. `test: add package install smoke coverage`
7. `ci: validate package installability`
8. `chore: add release workflow`

## Blockers

- Release credential strategy.
- GitHub ownership decision for long-term public package identity, if repo ownership should change before npm publish.
- Claude agent definitions are explicitly deferred until authored as real ADLC Claude agents.

## Next ADLC Step

Use `adlc-verify` or `adlc-review` on this implementation, then use `adlc-commit` when the diff is accepted.
