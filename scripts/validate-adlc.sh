#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

python3 - <<'PY'
import json
import re
import stat
import sys
from pathlib import Path

failures = []

def fail(message: str) -> None:
    failures.append(message)

required_files = [
    "README.md",
    "AGENTS.md",
    "CLAUDE.md",
    "package.json",
    "bin/adlc.js",
    ".claude-plugin/plugin.json",
    "docs/README.md",
    "docs/getting-started.md",
    "docs/workflow.md",
    "docs/configuration.md",
    "docs/config-reference.md",
    "docs/agents.md",
    "docs/skills.md",
    "docs/subagents.md",
    "docs/quality-gates.md",
    "docs/plan-files.md",
    "docs/workstreams.md",
    "docs/loop.md",
    "docs/evolve.md",
    "docs/extensions.md",
    "docs/security.md",
    "docs/mcp.md",
    "docs/artifact-audit.md",
    "docs/gate-result-schema.md",
    "docs/adr/0003-workstreams-for-managed-epics.md",
    "docs/adr/0004-agent-target-installer.md",
    ".adlc/plans/public-installability.md",
    "schemas/extension.schema.json",
    "extensions/README.md",
    "extensions/marketplace/hello-adlc/extension.json",
    "extensions/marketplace/hello-adlc/injections/implement-extra.md",
    "extensions/marketplace/hello-adlc/skills/hello-commit/SKILL.md",
    "mcp/templates/filesystem.json",
    "mcp/templates/github.json",
    "mcp/templates/postgres.json",
    "mcp/templates/playwright.json",
    "mcp/templates/chrome-devtools.json",
    "subagents/codex/config.toml",
    "templates/adlc/config.yaml",
    "scripts/test-adlc-cli.sh",
    "scripts/test-adlc-skill-fixtures.sh",
    "scripts/test-package-smoke.sh",
    "skills/adlc/adlc-architecture/references/ARCHITECTURE-CHECKLIST.md",
    "skills/adlc/adlc-security-checklist/references/AUTH-PATTERNS.md",
    "skills/adlc/adlc-security-checklist/references/PROMPT-INJECTION.md",
    "skills/adlc/adlc-security-checklist/references/RACE-CONDITIONS.md",
    "skills/adlc/adlc-security-checklist/scripts/audit.sh",
    "skills/adlc/adlc-plan/references/TASK-FORMAT.md",
    "skills/adlc/adlc-plan/references/EXAMPLES.md",
    "skills/adlc/adlc-implement/references/IMPLEMENTATION-GUIDE.md",
    "skills/adlc/adlc-implement/references/LOGGING-GUIDE.md",
    "skills/adlc/adlc-verify/references/CONTEXT-GATES-AND-OWNERSHIP.md",
    "skills/adlc/adlc-verify/references/GATE-RESULT-CONTRACT.md",
    "skills/adlc/adlc-loop/references/CRITERIA-TEMPLATES.md",
    "skills/adlc/adlc-loop/references/PHASE-CONTRACTS.md",
    "skills/adlc/adlc-loop/references/RULE-SCHEMA.md",
    "skills/adlc/adlc-workstream/references/WORKSTREAM-CONTRACT.md",
    "skills/adlc/adlc-workstream/templates/WORKSTREAM.md",
    "skills/adlc/adlc-workstream/templates/STEP.md",
    "skills/adlc/adlc-workstream/templates/MILESTONE.md",
    "skills/adlc/adlc-workstream/templates/CODEX-HANDOFF.md",
    "skills/adlc/adlc-qa/references/CHANGE-SUMMARY.md",
    "skills/adlc/adlc-qa/references/TEST-PLAN.md",
    "skills/adlc/adlc-qa/references/TEST-CASES.md",
    "skills/adlc/adlc-qa/templates/CHANGE-SUMMARY.md",
    "skills/adlc/adlc-qa/templates/TEST-PLAN.md",
    "skills/adlc/adlc-qa/templates/TEST-CASES.md",
    "skills/adlc/adlc-reference/references/EXAMPLES.md",
    "skills/adlc/adlc-rules-check/references/RULES-CHECK-CONTRACT.md",
    "skills/adlc/adlc-docs/references/REVIEW-CHECKLISTS.md",
]
for path in required_files:
    if not Path(path).is_file():
        fail(f"missing file: {path}")

removed_files = [
    "scripts/install-codex-adlc.sh",
    "scripts/init-adlc-project.sh",
    "docs/runtimes.md",
    "docs/ai-factory-port-audit.md",
    "docs/factory-parity-gap-plan.md",
    "docs/adr/0001-factory-inspired-adlc.md",
    "docs/adr/0002-adlc-framework-foundation.md",
    ".adlc/plans/factory-parity-foundation.md",
]
for path in removed_files:
    if Path(path).exists():
        fail(f"removed surface still exists: {path}")

for script in Path("scripts").glob("*.sh"):
    if not (script.stat().st_mode & stat.S_IXUSR):
        fail(f"script is not executable: {script}")

try:
    plugin = json.loads(Path(".claude-plugin/plugin.json").read_text())
except Exception as exc:
    fail(f"plugin manifest is invalid JSON: {exc}")
    plugin = {}

try:
    package = json.loads(Path("package.json").read_text())
except Exception as exc:
    fail(f"package.json is invalid JSON: {exc}")
    package = {}

if package.get("name") != "adlc-cli":
    fail("package name must be adlc-cli")
if package.get("private") is True:
    fail("package must not be private for public installability")
if package.get("bin", {}).get("adlc") != "./bin/adlc.js":
    fail("package must expose the adlc CLI at ./bin/adlc.js")
for key in ["repository", "homepage", "bugs", "keywords", "engines", "packageManager"]:
    if key not in package:
        fail(f"package metadata missing {key}")
for script_name in ["adlc", "agents", "init", "status", "update", "doctor", "uninstall", "resolve:config", "workstream", "mcp:list", "extension:list", "audit:artifacts", "pack:dry-run", "test:cli", "test:skill-fixtures", "test:package-smoke"]:
    if script_name not in package.get("scripts", {}):
        fail(f"package scripts missing {script_name}")

entries = plugin.get("skills", [])
if plugin.get("name") != "adlc":
    fail("plugin name must be adlc")
if not isinstance(entries, list) or not entries:
    fail("plugin skills must be a non-empty list")

readme = Path("README.md").read_text() if Path("README.md").exists() else ""
for forbidden_readme_text in ["David", "Victor", "Factory", "factory", "lee-to", "upstream", "`aif", "install-codex", "--runtime", "codex-project", "claude-project", "codex-home", "universal-project"]:
    if forbidden_readme_text in readme:
        fail(f"README contains removed framing or command: {forbidden_readme_text}")
for required_text in ["npm install -g adlc-cli", "adlc init", "--agents codex,claude", ".adlc/managed-state.json", ".codex/config.toml", "mcp configure", "extension add", "audit-artifacts", "gate-result-schema.md"]:
    if required_text not in readme:
        fail(f"README must document {required_text}")
for required_doc in [
    "docs/getting-started.md",
    "docs/workflow.md",
    "docs/configuration.md",
    "docs/config-reference.md",
    "docs/agents.md",
    "docs/skills.md",
    "docs/subagents.md",
    "docs/quality-gates.md",
    "docs/plan-files.md",
    "docs/workstreams.md",
    "docs/loop.md",
    "docs/evolve.md",
    "docs/extensions.md",
    "docs/security.md",
    "docs/mcp.md",
    "docs/artifact-audit.md",
]:
    if required_doc not in readme:
        fail(f"README must link {required_doc}")

public_text_files = [
    "README.md",
    "AGENTS.md",
    "docs/README.md",
    "docs/getting-started.md",
    "docs/agents.md",
    "docs/mcp.md",
    "docs/extensions.md",
    "docs/security.md",
    "package.json",
]
for path in public_text_files:
    text = Path(path).read_text()
    for forbidden in ["Factory", "factory", "lee-to", "upstream", "@davidvictor", "install-codex", "--runtime"]:
        if forbidden in text:
            fail(f"{path} contains removed public surface: {forbidden}")

docs_index = Path("docs/README.md").read_text() if Path("docs/README.md").exists() else ""
for doc in ["getting-started.md", "workflow.md", "configuration.md", "config-reference.md", "agents.md", "skills.md", "subagents.md", "quality-gates.md", "plan-files.md", "loop.md", "evolve.md", "extensions.md", "security.md", "mcp.md", "artifact-audit.md", "workstreams.md"]:
    if doc not in docs_index:
        fail(f"docs index must mention {doc}")

skill_files = sorted(Path("skills/adlc").glob("*/SKILL.md"))
skill_names = [p.parent.name for p in skill_files]
expected = {
    "adlc",
    "adlc-explore",
    "adlc-grounded",
    "adlc-architecture",
    "adlc-roadmap",
    "adlc-rules",
    "adlc-reference",
    "adlc-plan",
    "adlc-workstream",
    "adlc-improve",
    "adlc-implement",
    "adlc-verify",
    "adlc-rules-check",
    "adlc-security-checklist",
    "adlc-review",
    "adlc-docs",
    "adlc-qa",
    "adlc-commit",
    "adlc-fix",
    "adlc-loop",
    "adlc-evolve",
}
if set(skill_names) != expected:
    fail(f"ADLC skills mismatch: got {sorted(skill_names)}, expected {sorted(expected)}")

frontmatter_re = re.compile(r"^---\n(.*?)\n---\n", re.DOTALL)
for skill_file in skill_files:
    skill_name = skill_file.parent.name
    text = skill_file.read_text()
    match = frontmatter_re.match(text)
    if not match:
        fail(f"missing frontmatter: {skill_file}")
        continue
    fields = {}
    for line in match.group(1).splitlines():
        if ":" in line:
            key, value = line.split(":", 1)
            fields[key.strip()] = value.strip()
    if fields.get("name") != skill_name:
        fail(f"frontmatter name mismatch: {skill_file}")
    description = fields.get("description", "")
    if len(description) < 25:
        fail(f"description too short: {skill_file}")
    metadata = skill_file.parent / "agents" / "openai.yaml"
    if not metadata.is_file():
        fail(f"missing OpenAI metadata: {metadata}")
    metadata_text = metadata.read_text()
    if "$aif" in metadata_text or "AIF" in metadata_text:
        fail(f"metadata still references AIF prompt/name: {metadata}")
    if skill_name not in readme:
        fail(f"README does not mention {skill_name}")
    plugin_entry = f"./skills/adlc/{skill_name}"
    if plugin_entry not in entries:
        fail(f"plugin manifest missing {plugin_entry}")
    if "resolve-config" not in text:
        fail(f"skill must mention config resolver: {skill_file}")

for gate_skill in ["adlc-review", "adlc-verify", "adlc-rules-check", "adlc-security-checklist"]:
    text = Path("skills/adlc", gate_skill, "SKILL.md").read_text()
    for required in [
        "```adlc-gate-result",
        "\"schema_version\": 1",
        "\"blocking\"",
        "\"blockers\"",
        "\"affected_files\"",
        "\"suggested_next\"",
    ]:
        if required not in text:
            fail(f"{gate_skill} output contract missing {required}")

for skill_name in ["adlc-plan", "adlc-implement", "adlc-verify"]:
    tests_dir = Path("skills/adlc", skill_name, "tests")
    if not tests_dir.is_dir() or not list(tests_dir.glob("*.yaml")):
        fail(f"{skill_name} must keep YAML fixture tests")

for skill_name in ["adlc-architecture", "adlc-plan", "adlc-workstream", "adlc-implement", "adlc-verify", "adlc-loop", "adlc-qa", "adlc-reference", "adlc-rules-check", "adlc-security-checklist", "adlc-docs"]:
    refs_dir = Path("skills/adlc", skill_name, "references")
    if not refs_dir.is_dir() or not list(refs_dir.glob("*.md")):
        fail(f"{skill_name} must keep ADLC-native reference docs")

cli_text = Path("bin/adlc.js").read_text()
for command_name in ["agents", "status", "update", "doctor", "uninstall", "upgrade", "mcp", "extension", "resolve-config", "workstream", "audit-artifacts"]:
    if f"case '{command_name}'" not in cli_text:
        fail(f"adlc CLI missing command case: {command_name}")
for removed_command in ["case 'runtimes'", "case 'install'", "case 'install-codex'"]:
    if removed_command in cli_text:
        fail(f"adlc CLI still exposes removed command: {removed_command}")
for required_cli_text in ["agentRegistry", "managedConfigSource", "stripAdlcMcpBlocks", "kind: 'config'", "config.toml", "workstreamRoot", "codex-goal"]:
    if required_cli_text not in cli_text:
        fail(f"adlc CLI missing installer capability: {required_cli_text}")
for required_cli_text in ["applyExtensionInjection", "installedReplacements", "installedInjections", "removeExtensionMcp"]:
    if required_cli_text not in cli_text:
        fail(f"adlc CLI must support local extension replacement/injection cleanup: missing {required_cli_text}")

extension_schema = Path("schemas/extension.schema.json").read_text()
for required_schema_field in ["replaces", "injections", "mcpServers", "agentFiles", "\"agent\""]:
    if required_schema_field not in extension_schema:
        fail(f"extension schema missing {required_schema_field}")

for entry in entries:
    if "aif" in entry:
        fail(f"plugin entry references replaced AIF surface: {entry}")
    if not Path(entry, "SKILL.md").is_file():
        fail(f"plugin entry missing SKILL.md: {entry}")

required_agents = {
    "plan-coordinator.toml",
    "plan-polisher.toml",
    "implement-coordinator.toml",
    "implement-worker.toml",
    "review-sidecar.toml",
    "security-sidecar.toml",
    "rules-sidecar.toml",
    "docs-auditor.toml",
    "best-practices-sidecar.toml",
    "commit-preparer.toml",
}
agent_files = {p.name for p in Path("subagents/codex/agents").glob("*.toml")}
if agent_files != required_agents:
    fail(f"Codex agent set mismatch: got {sorted(agent_files)}, expected {sorted(required_agents)}")

for agent_file in sorted(Path("subagents/codex/agents").glob("*.toml")):
    text = agent_file.read_text()
    if "name =" not in text or "developer_instructions" not in text:
        fail(f"agent file missing required fields: {agent_file}")
    if 'model = "gpt-5.5"' not in text:
        fail(f"agent file must use gpt-5.5: {agent_file}")

high_effort_agents = {
    "implement-worker.toml",
    "plan-polisher.toml",
    "review-sidecar.toml",
    "security-sidecar.toml",
}
medium_effort_agents = required_agents - high_effort_agents
for agent_name in sorted(high_effort_agents):
    text = Path("subagents/codex/agents", agent_name).read_text()
    if 'model_reasoning_effort = "high"' not in text:
        fail(f"{agent_name} must use high reasoning effort")
for agent_name in sorted(medium_effort_agents):
    text = Path("subagents/codex/agents", agent_name).read_text()
    if 'model_reasoning_effort = "medium"' not in text:
        fail(f"{agent_name} must use medium reasoning effort")

if failures:
    for message in failures:
        print(f"FAIL: {message}", file=sys.stderr)
    print(f"\n{len(failures)} validation failure(s)", file=sys.stderr)
    sys.exit(1)

print(f"ADLC validation passed for {len(skill_files)} skills and {len(agent_files)} Codex agents.")
PY
