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
    ".claude-plugin/plugin.json",
    "docs/ai-factory-port-audit.md",
    "docs/adr/0001-factory-inspired-adlc.md",
    "templates/adlc/config.yaml",
    "scripts/init-adlc-project.sh",
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

entries = plugin.get("skills", [])
if plugin.get("name") != "adlc":
    fail("plugin name must be adlc")
if not isinstance(entries, list) or not entries:
    fail("plugin skills must be a non-empty list")

readme = Path("README.md").read_text() if Path("README.md").exists() else ""
if "David Factory" in readme or "`aif" in readme:
    fail("README still references the old David Factory/aif public surface")

skill_files = sorted(Path("skills/adlc").glob("*/SKILL.md"))
skill_names = [p.parent.name for p in skill_files]
expected = {
    "adlc",
    "adlc-explore",
    "adlc-grounded",
    "adlc-plan",
    "adlc-improve",
    "adlc-implement",
    "adlc-verify",
    "adlc-review",
    "adlc-commit",
    "adlc-fix",
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
