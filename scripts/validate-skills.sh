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

root = Path(".")
failures = []

def fail(message: str) -> None:
    failures.append(message)

def require_file(path: str) -> None:
    if not Path(path).is_file():
        fail(f"missing file: {path}")

for required in [
    "README.md",
    "skills/engineering/README.md",
    ".claude-plugin/plugin.json",
    "AGENTS.md",
    "CLAUDE.md",
    "docs/examples/README.md",
    "docs/public-release-checklist.md",
]:
    require_file(required)

for script in Path("scripts").glob("*.sh"):
    mode = script.stat().st_mode
    if not (mode & stat.S_IXUSR):
        fail(f"script is not executable: {script}")

skill_files = sorted(Path("skills/engineering").glob("adlc-*/SKILL.md"))
if not skill_files:
    fail("no skills found")

try:
    plugin = json.loads(Path(".claude-plugin/plugin.json").read_text())
except Exception as exc:
    fail(f"plugin manifest is invalid JSON: {exc}")
    plugin = {}

plugin_entries = plugin.get("skills", [])
if not isinstance(plugin_entries, list):
    fail("plugin skills must be a list")
    plugin_entries = []

if len(plugin_entries) != len(set(plugin_entries)):
    fail("plugin contains duplicate skill entries")

readme = Path("README.md").read_text() if Path("README.md").exists() else ""
engineering_readme = Path("skills/engineering/README.md").read_text() if Path("skills/engineering/README.md").exists() else ""
plugin_entry_set = set(plugin_entries)

frontmatter_re = re.compile(r"^---\n(.*?)\n---\n", re.DOTALL)
link_re = re.compile(r"\[[^\]]+\]\(([^)]+)\)")

def parse_simple_yaml(path: Path) -> dict:
    data = {}
    stack = [data]
    indents = [0]
    for raw_line in path.read_text().splitlines():
        if not raw_line.strip() or raw_line.lstrip().startswith("#"):
            continue
        indent = len(raw_line) - len(raw_line.lstrip(" "))
        line = raw_line.strip()
        if ":" not in line:
            fail(f"unsupported yaml line in {path}: {raw_line}")
            continue
        key, value = line.split(":", 1)
        key = key.strip()
        value = value.strip()
        while indent < indents[-1] and len(stack) > 1:
            stack.pop()
            indents.pop()
        if value == "":
            child = {}
            stack[-1][key] = child
            stack.append(child)
            indents.append(indent + 2)
        else:
            if value.startswith('"') and value.endswith('"'):
                value = value[1:-1]
            elif value in {"true", "false"}:
                value = value == "true"
            stack[-1][key] = value
    return data

for skill_file in skill_files:
    skill_dir = skill_file.parent
    skill_name = skill_dir.name
    plugin_entry = f"./{skill_dir.as_posix()}"
    text = skill_file.read_text()

    if not skill_name.startswith("adlc-"):
        fail(f"skill folder lacks adlc- prefix: {skill_dir}")
    if not text.strip():
        fail(f"empty SKILL.md: {skill_file}")

    match = frontmatter_re.match(text)
    if not match:
        fail(f"missing frontmatter block: {skill_file}")
        frontmatter = ""
    else:
        frontmatter = match.group(1)

    fields = {}
    for line in frontmatter.splitlines():
        if ":" in line:
            key, value = line.split(":", 1)
            fields[key.strip()] = value.strip()

    if fields.get("name") != skill_name:
        fail(f"frontmatter name mismatch in {skill_file}")
    description = fields.get("description", "")
    if not description:
        fail(f"missing description in {skill_file}")
    elif len(description) < 25:
        fail(f"description too short in {skill_file}")
    elif len(description) > 1024:
        fail(f"description too long in {skill_file}")

    if skill_name not in readme:
        fail(f"README.md does not list {skill_name}")
    if skill_name not in engineering_readme:
        fail(f"skills/engineering/README.md does not list {skill_name}")
    if plugin_entry not in plugin_entry_set:
        fail(f"plugin manifest does not list {plugin_entry}")

    metadata_file = skill_dir / "agents" / "openai.yaml"
    if not metadata_file.is_file():
        fail(f"missing OpenAI metadata: {metadata_file}")
    else:
        metadata = parse_simple_yaml(metadata_file)
        interface = metadata.get("interface", {})
        policy = metadata.get("policy", {})
        display_name = interface.get("display_name", "")
        short_description = interface.get("short_description", "")
        default_prompt = interface.get("default_prompt", "")
        if not display_name:
            fail(f"metadata missing display_name: {metadata_file}")
        if len(short_description) < 25 or len(short_description) > 64:
            fail(f"metadata short_description must be 25-64 chars: {metadata_file}")
        if f"${skill_name}" not in default_prompt:
            fail(f"metadata default_prompt must mention ${skill_name}: {metadata_file}")
        if policy.get("allow_implicit_invocation") is not True:
            fail(f"metadata policy.allow_implicit_invocation must be true: {metadata_file}")

    for target in link_re.findall(text):
        if target.startswith(("http://", "https://", "#", "/")):
            continue
        target_no_anchor = target.split("#", 1)[0]
        if not target_no_anchor:
            continue
        if not (skill_dir / target_no_anchor).exists():
            fail(f"broken link in {skill_file}: {target}")

for entry in plugin_entries:
    if not isinstance(entry, str):
        fail("plugin skill entries must be strings")
        continue
    path = Path(entry)
    skill_file = path / "SKILL.md"
    skill_name = path.name
    if not skill_file.is_file():
        fail(f"plugin entry missing SKILL.md: {entry}")
    if skill_name not in readme:
        fail(f"plugin skill missing from README.md: {skill_name}")
    if skill_name not in engineering_readme:
        fail(f"plugin skill missing from engineering README: {skill_name}")

for docs_file in [Path("docs/examples/README.md"), Path("README.md"), Path("docs/public-release-checklist.md")]:
    if not docs_file.is_file():
        continue
    for target in link_re.findall(docs_file.read_text()):
        if target.startswith(("http://", "https://", "#", "/")):
            continue
        target_no_anchor = target.split("#", 1)[0]
        if not target_no_anchor:
            continue
        if not (docs_file.parent / target_no_anchor).exists():
            fail(f"broken link in {docs_file}: {target}")

if failures:
    for message in failures:
        print(f"FAIL: {message}", file=sys.stderr)
    print(f"\n{len(failures)} validation failure(s)", file=sys.stderr)
    sys.exit(1)

print(f"Skill validation passed for {len(skill_files)} skills.")
PY
