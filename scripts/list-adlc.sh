#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

find "$repo_root/skills/adlc" -mindepth 2 -maxdepth 2 -name SKILL.md -print |
  sort |
  while IFS= read -r skill_file; do
    skill_dir="$(dirname "$skill_file")"
    skill_name="$(basename "$skill_dir")"
    description="$(awk '
      BEGIN { in_frontmatter=0 }
      NR == 1 && $0 == "---" { in_frontmatter=1; next }
      in_frontmatter && $0 == "---" { exit }
      in_frontmatter && /^description:/ {
        sub(/^description:[[:space:]]*/, "")
        print
        exit
      }
    ' "$skill_file")"
    printf "%s\t%s\n" "$skill_name" "$description"
  done

echo
echo "Codex agents:"
find "$repo_root/subagents/codex/agents" -maxdepth 1 -type f -name '*.toml' -print |
  sort |
  sed 's#.*/##; s#\.toml$##'
