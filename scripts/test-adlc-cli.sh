#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/adlc-cli-test.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

cd "$repo_root"

node bin/adlc.js help >/dev/null
node bin/adlc.js list >/dev/null
node bin/adlc.js agents >/dev/null
node bin/adlc.js mcp list >/dev/null
node bin/adlc.js workstream help >/dev/null
node bin/adlc.js upgrade >/dev/null
node bin/adlc.js resolve-config --json >/dev/null
node bin/adlc.js audit-artifacts --strict docs README.md AGENTS.md >/dev/null

node bin/adlc.js init "$tmp_dir" --agents codex,claude,hermes --mcp filesystem >/dev/null
test -f "$tmp_dir/.adlc/config.yaml"
test -f "$tmp_dir/.adlc/DESCRIPTION.md"
test -f "$tmp_dir/.adlc/ARCHITECTURE.md"
test -f "$tmp_dir/.adlc/RULES.md"
test -f "$tmp_dir/.adlc/managed-state.json"
test -d "$tmp_dir/.adlc/references"
test -d "$tmp_dir/.adlc/loops"
test -d "$tmp_dir/.adlc/workstreams"
test -f "$tmp_dir/.codex/config.toml"
test -f "$tmp_dir/.codex/agents/implement-worker.toml"
test -f "$tmp_dir/.codex/skills/adlc/SKILL.md"
test -f "$tmp_dir/.claude/skills/adlc/SKILL.md"
test -f "$tmp_dir/.mcp.json"
test -f "$tmp_dir/.hermes/config.yaml"
test -f "$tmp_dir/.hermes/kanban.json"
grep -q "max_threads = 6" "$tmp_dir/.codex/config.toml"
grep -q "BEGIN ADLC MCP filesystem" "$tmp_dir/.codex/config.toml"
grep -q '"filesystem"' "$tmp_dir/.mcp.json"

node bin/adlc.js agents --json | grep -q '"id": "hermes"'
node bin/adlc.js resolve-config "$tmp_dir" --json | grep -q '"config_exists": true'
node bin/adlc.js status "$tmp_dir" --strict >/dev/null
node bin/adlc.js doctor "$tmp_dir" --strict >/dev/null
node bin/adlc.js update "$tmp_dir" >/dev/null
node bin/adlc.js mcp remove filesystem "$tmp_dir" --agents codex,claude >/dev/null
if grep -q "BEGIN ADLC MCP filesystem" "$tmp_dir/.codex/config.toml"; then
  echo "MCP filesystem block was not removed" >&2
  exit 1
fi
node bin/adlc.js mcp configure filesystem "$tmp_dir" --agents codex,claude >/dev/null

node bin/adlc.js workstream create project-automation "$tmp_dir" --executor hermes >/dev/null
test -f "$tmp_dir/.adlc/workstreams/project-automation/WORKSTREAM.md"
test -f "$tmp_dir/.adlc/workstreams/project-automation/handoff/hermes.md"
grep -q "| fix |" "$tmp_dir/.adlc/workstreams/project-automation/kanban.md"
node bin/adlc.js workstream status project-automation "$tmp_dir" --json | grep -q '"stage": "ready"'
node bin/adlc.js workstream advance project-automation 0001 "$tmp_dir" --stage build >/dev/null
node bin/adlc.js workstream status project-automation "$tmp_dir" --json | grep -q '"stage": "build"'
node bin/adlc.js workstream advance project-automation 0001 "$tmp_dir" --stage review >/dev/null
node bin/adlc.js workstream advance project-automation 0001 "$tmp_dir" --stage fix >/dev/null
node bin/adlc.js workstream status project-automation "$tmp_dir" --json | grep -q '"stage": "fix"'
node bin/adlc.js workstream sync project-automation "$tmp_dir" --agent hermes >/dev/null
test -f "$tmp_dir/.hermes/inbox/project-automation.md"
test -d "$tmp_dir/.hermes/workstreams/project-automation/steps"
grep -q "hermes-card-adlc-workstream-project-automation-0001" "$tmp_dir/.hermes/kanban.json"
node -e "const kanban = require(process.argv[1]); const card = 'hermes-card-adlc-workstream-project-automation-0001'; if (!Array.isArray(kanban.lanes.fix) || !kanban.lanes.fix.includes(card)) process.exit(1)" "$tmp_dir/.hermes/kanban.json"

node bin/adlc.js extension validate extensions/marketplace/hello-adlc >/dev/null
node bin/adlc.js extension add extensions/marketplace/hello-adlc "$tmp_dir" --agents codex >/dev/null
node bin/adlc.js extension list "$tmp_dir" | grep -q "hello-adlc"
test -f "$tmp_dir/.codex/skills/hello-adlc/SKILL.md"
grep -q "Hello Commit Replacement" "$tmp_dir/.codex/skills/adlc-commit/SKILL.md"
grep -q "BEGIN ADLC MCP hello-adlc" "$tmp_dir/.codex/config.toml"
grep -q "Hello ADLC Extension" "$tmp_dir/.codex/skills/adlc-implement/SKILL.md"
node bin/adlc.js extension remove hello-adlc "$tmp_dir" >/dev/null
test ! -e "$tmp_dir/.codex/skills/hello-adlc"
grep -q "# ADLC Commit" "$tmp_dir/.codex/skills/adlc-commit/SKILL.md"
if grep -q "BEGIN ADLC MCP hello-adlc" "$tmp_dir/.codex/config.toml"; then
  echo "Extension MCP block was not removed" >&2
  exit 1
fi
if grep -q "Hello ADLC Extension" "$tmp_dir/.codex/skills/adlc-implement/SKILL.md"; then
  echo "Extension injection was not removed" >&2
  exit 1
fi

node bin/adlc.js uninstall "$tmp_dir" --agents hermes >/dev/null
test ! -f "$tmp_dir/.hermes/config.yaml"
node bin/adlc.js validate >/dev/null

echo "ADLC CLI fixture test passed."
