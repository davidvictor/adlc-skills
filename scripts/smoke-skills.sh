#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

scripts/validate-skills.sh

skill_count="$(scripts/list-skills.sh | wc -l | tr -d ' ')"
if [[ "$skill_count" != "22" ]]; then
  echo "Expected 22 public skills, found $skill_count" >&2
  exit 1
fi

python3 - <<'PY'
import json
from pathlib import Path

plugin = json.loads(Path(".claude-plugin/plugin.json").read_text())
assert len(plugin["skills"]) == 22
assert Path("skills/engineering/adlc-plan/PLAN-WORKFLOW.md").is_file()
assert Path("skills/engineering/adlc-sprint/SPRINT-PACKAGE.md").is_file()
assert Path("skills/engineering/adlc-sprint/SPRINT-MATERIALS.md").is_file()
assert Path("skills/engineering/adlc-sprint/EXECUTION-ARCHITECTURES.md").is_file()
assert Path("skills/engineering/adlc-hermes/HERMES-HANDOFF.md").is_file()
assert Path("skills/engineering/adlc-hermes/HERMES-ADLC-PHASES.md").is_file()
assert Path("scripts/check-hermes-adlc-ready.sh").is_file()
assert Path("scripts/install-codex-adlc-skills.sh").is_file()
assert Path("scripts/install-hermes-adlc-skills.sh").is_file()
assert Path("scripts/setup-hermes-adlc-profiles.sh").is_file()
assert Path("scripts/seed-adlc-hermes-sprint.sh").is_file()
assert Path("docs/examples/lifecycle-thread.md").is_file()
assert Path("skills/engineering/adlc-setup/TRACKER-ADAPTERS.md").is_file()
assert Path("skills/engineering/adlc-build/TDD-LOOP.md").is_file()
assert Path("skills/engineering/adlc-interface/VISUAL-DIRECTION.md").is_file()
PY

echo "Skill smoke check passed."
