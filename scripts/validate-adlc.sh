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
    "docs/skills.md",
    "docs/subagents.md",
    "docs/quality-gates.md",
    "docs/plan-files.md",
    "docs/workstreams.md",
    "docs/loop.md",
    "docs/evolve.md",
    "docs/extensions.md",
    "docs/security.md",
    "docs/runtimes.md",
    "docs/mcp.md",
    "docs/artifact-audit.md",
    "docs/ai-factory-port-audit.md",
    "docs/factory-parity-gap-plan.md",
    "docs/gate-result-schema.md",
    "docs/adr/0001-factory-inspired-adlc.md",
    "docs/adr/0002-adlc-framework-foundation.md",
    "docs/adr/0003-workstreams-for-managed-epics.md",
    ".adlc/plans/factory-parity-foundation.md",
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
    "scripts/init-adlc-project.sh",
    "scripts/test-adlc-cli.sh",
    "scripts/test-adlc-skill-fixtures.sh",
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
    "skills/adlc/adlc-workstream/templates/CODEX-HANDOFF.md",
    "skills/adlc/adlc-workstream/templates/HERMES-HANDOFF.md",
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

for script in Path("scripts").glob("*.sh"):
    if not (script.stat().st_mode & stat.S_IXUSR):
        fail(f"script is not executable: {script}")

install_script = Path("scripts/install-codex-adlc.sh").read_text()
if "find \"$skills_dest\"" not in install_script or "-name 'aif*'" not in install_script:
    fail("install script must remove replaced aif* skills from the Codex skills directory")
if "-name 'adlc*'" not in install_script:
    fail("install script must refresh previously installed adlc* skills before syncing")
if "--exclude 'tests/'" not in install_script:
    fail("install script must not sync skill fixture tests into Codex skill dirs")

if Path("skills/factory").exists():
    fail("old factory skill directory remains: skills/factory")
old_aif_skills = sorted(Path("skills").glob("**/aif*"))
if old_aif_skills:
    fail("aif skill paths remain: " + ", ".join(str(p) for p in old_aif_skills[:10]))

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

if package.get("name") != "@davidvictor/adlc":
    fail("package name must be @davidvictor/adlc")
if package.get("private") is not True:
    fail("package must remain private until ADLC has a real CLI/update contract")
if package.get("bin", {}).get("adlc") != "./bin/adlc.js":
    fail("package must expose the repo-local adlc CLI at ./bin/adlc.js")
for script_name in ["adlc", "runtimes", "status", "install:runtime", "update:codex", "resolve:config", "workstream", "mcp:list", "extension:list", "audit:artifacts", "test:cli", "test:skill-fixtures"]:
    if script_name not in package.get("scripts", {}):
        fail(f"package scripts missing {script_name}")

entries = plugin.get("skills", [])
if plugin.get("name") != "adlc":
    fail("plugin name must be adlc")
if not isinstance(entries, list) or not entries:
    fail("plugin skills must be a non-empty list")

readme = Path("README.md").read_text() if Path("README.md").exists() else ""
if "David Factory" in readme or "`aif" in readme:
    fail("README still references the old David Factory/aif public surface")
if "factory-parity-gap-plan.md" not in readme:
    fail("README must link the active factory parity gap plan")
if "audit-artifacts" not in readme:
    fail("README must document the artifact audit command")
if "gate-result-schema.md" not in readme:
    fail("README must document the ADLC gate result schema")
if "adlc-managed-state.json" not in readme:
    fail("README must document managed install state")
if "resolve-config" not in readme:
    fail("README must document config resolution")
if ".codex/config.toml" not in readme:
    fail("README must document managed Codex project config")
for required_text in ["mcp configure", "extension add", "codex-project", "claude-project", "upgrade"]:
    if required_text not in readme:
        fail(f"README must document {required_text}")
for required_doc in [
    "docs/getting-started.md",
    "docs/workflow.md",
    "docs/configuration.md",
    "docs/config-reference.md",
    "docs/skills.md",
    "docs/subagents.md",
    "docs/quality-gates.md",
    "docs/plan-files.md",
    "docs/workstreams.md",
    "docs/loop.md",
    "docs/evolve.md",
    "docs/extensions.md",
    "docs/security.md",
    "docs/runtimes.md",
    "docs/mcp.md",
    "docs/artifact-audit.md",
]:
    if required_doc not in readme and required_doc != "docs/README.md":
        fail(f"README must link {required_doc}")

docs_index = Path("docs/README.md").read_text() if Path("docs/README.md").exists() else ""
for upstream_doc in [
    "getting-started.md",
    "workflow.md",
    "configuration.md",
    "config-reference.md",
    "skills.md",
    "subagents.md",
    "quality-gates.md",
    "plan-files.md",
    "loop.md",
    "evolve.md",
    "extensions.md",
    "security.md",
]:
    if f"`{upstream_doc}`" not in docs_index:
        fail(f"docs index must map upstream guide {upstream_doc} to an ADLC guide")
for adlc_doc in ["runtimes.md", "mcp.md", "artifact-audit.md", "workstreams.md"]:
    if adlc_doc not in docs_index:
        fail(f"docs index must mention ADLC-specific guide {adlc_doc}")

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

if not Path("skills/adlc/adlc-qa/templates/TEST-PLAN.md").is_file():
    fail("adlc-qa must keep QA templates")

cli_text = Path("bin/adlc.js").read_text()
for command_name in ["runtimes", "status", "install", "update", "upgrade", "mcp", "extension", "resolve-config", "workstream", "install-codex", "audit-artifacts"]:
    if f"case '{command_name}'" not in cli_text:
        fail(f"adlc CLI missing command case: {command_name}")
for required_cli_text in ["managedConfig", "stripAdlcMcpBlocks", "kind: 'config'", "config.toml"]:
    if required_cli_text not in cli_text:
        fail(f"adlc CLI must manage Codex config files: missing {required_cli_text}")
for required_cli_text in ["applyExtensionInjection", "installedReplacements", "installedInjections", "removeExtensionMcp"]:
    if required_cli_text not in cli_text:
        fail(f"adlc CLI must support local extension replacement/injection cleanup: missing {required_cli_text}")

extension_schema = Path("schemas/extension.schema.json").read_text()
for required_schema_field in ["replaces", "injections", "mcpServers", "agentFiles"]:
    if required_schema_field not in extension_schema:
        fail(f"extension schema missing {required_schema_field}")

for entry in entries:
    if "aif" in entry or "factory" in entry:
        fail(f"plugin entry references replaced factory surface: {entry}")
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

if failures:
    for message in failures:
        print(f"FAIL: {message}", file=sys.stderr)
    print(f"\n{len(failures)} validation failure(s)", file=sys.stderr)
    sys.exit(1)

print(f"ADLC validation passed for {len(skill_files)} skills and {len(agent_files)} Codex agents.")
PY
