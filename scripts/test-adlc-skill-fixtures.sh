#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

required_paths=(
  "skills/adlc/adlc-plan/references/TASK-FORMAT.md"
  "skills/adlc/adlc-plan/references/EXAMPLES.md"
  "skills/adlc/adlc-plan/tests/fast-creates-plan-md.yaml"
  "skills/adlc/adlc-implement/references/IMPLEMENTATION-GUIDE.md"
  "skills/adlc/adlc-implement/references/LOGGING-GUIDE.md"
  "skills/adlc/adlc-implement/tests/without-plan-empty-errors.yaml"
  "skills/adlc/adlc-verify/references/CONTEXT-GATES-AND-OWNERSHIP.md"
  "skills/adlc/adlc-verify/references/GATE-RESULT-CONTRACT.md"
  "skills/adlc/adlc-verify/tests/sequential-plan-discovery.yaml"
  "skills/adlc/adlc-loop/references/CRITERIA-TEMPLATES.md"
  "skills/adlc/adlc-loop/references/PHASE-CONTRACTS.md"
  "skills/adlc/adlc-loop/references/RULE-SCHEMA.md"
  "skills/adlc/adlc-qa/references/CHANGE-SUMMARY.md"
  "skills/adlc/adlc-qa/references/TEST-PLAN.md"
  "skills/adlc/adlc-qa/references/TEST-CASES.md"
  "skills/adlc/adlc-qa/templates/CHANGE-SUMMARY.md"
  "skills/adlc/adlc-qa/templates/TEST-PLAN.md"
  "skills/adlc/adlc-qa/templates/TEST-CASES.md"
  "skills/adlc/adlc-reference/references/EXAMPLES.md"
  "skills/adlc/adlc-rules-check/references/RULES-CHECK-CONTRACT.md"
  "skills/adlc/adlc-docs/references/REVIEW-CHECKLISTS.md"
  "skills/adlc/adlc-architecture/references/ARCHITECTURE-CHECKLIST.md"
  "skills/adlc/adlc-security-checklist/references/AUTH-PATTERNS.md"
  "skills/adlc/adlc-security-checklist/references/PROMPT-INJECTION.md"
  "skills/adlc/adlc-security-checklist/references/RACE-CONDITIONS.md"
  "skills/adlc/adlc-workstream/references/WORKSTREAM-CONTRACT.md"
  "skills/adlc/adlc-workstream/templates/WORKSTREAM.md"
  "skills/adlc/adlc-workstream/templates/STEP.md"
  "skills/adlc/adlc-workstream/templates/CODEX-HANDOFF.md"
  "skills/adlc/adlc-workstream/templates/HERMES-HANDOFF.md"
)

for path in "${required_paths[@]}"; do
  test -s "$path"
done

grep -q "adlc-gate-result" skills/adlc/adlc-verify/references/GATE-RESULT-CONTRACT.md
grep -q "Write scope" skills/adlc/adlc-plan/references/TASK-FORMAT.md
grep -q "bounded" skills/adlc/adlc-implement/references/IMPLEMENTATION-GUIDE.md
grep -q "Pass Criteria" skills/adlc/adlc-qa/templates/TEST-PLAN.md
grep -q "architecture artifact" skills/adlc/adlc-architecture/SKILL.md
grep -q '"gate": "security"' skills/adlc/adlc-security-checklist/SKILL.md
grep -q "build -> review -> fix -> test -> commit" skills/adlc/adlc-workstream/references/WORKSTREAM-CONTRACT.md
grep -q "Hermes" skills/adlc/adlc-workstream/templates/HERMES-HANDOFF.md

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/adlc-skill-install.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

node bin/adlc.js init "$tmp_dir" --agents codex >/dev/null
test -f "$tmp_dir/.codex/skills/adlc-plan/references/TASK-FORMAT.md"
test -f "$tmp_dir/.codex/skills/adlc-workstream/templates/WORKSTREAM.md"
test ! -e "$tmp_dir/.codex/skills/adlc-plan/tests"

echo "ADLC skill fixture test passed."
