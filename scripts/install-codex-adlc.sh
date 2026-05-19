#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_home="${CODEX_HOME:-$HOME/.codex}"
skills_dest="$codex_home/skills"
agents_dest="$codex_home/agents"

mkdir -p "$skills_dest" "$agents_dest"

removed_count=0
while IFS= read -r old_skill_dir; do
  rm -rf "$old_skill_dir"
  echo "Removed replaced skill: $old_skill_dir"
  removed_count=$((removed_count + 1))
done < <(find "$skills_dest" -mindepth 1 -maxdepth 1 -type d \( -name 'aif*' -o -name 'adlc*' \) | sort)

skill_count=0
while IFS= read -r skill_dir; do
  skill_name="$(basename "$skill_dir")"
  dest="$skills_dest/$skill_name"
  if [[ -L "$dest" ]]; then
    rm "$dest"
  fi
  mkdir -p "$dest"
  rsync -a --delete "$skill_dir"/ "$dest"/
  echo "Synced ADLC skill: $dest"
  skill_count=$((skill_count + 1))
done < <(find "$repo_root/skills/adlc" -mindepth 1 -maxdepth 1 -type d \( -name 'adlc' -o -name 'adlc-*' \) | sort)

agent_count=0
while IFS= read -r agent_file; do
  dest="$agents_dest/$(basename "$agent_file")"
  cp "$agent_file" "$dest"
  echo "Synced Codex agent: $dest"
  agent_count=$((agent_count + 1))
done < <(find "$repo_root/subagents/codex/agents" -maxdepth 1 -type f -name '*.toml' | sort)

echo
echo "Removed $removed_count replaced skills from $skills_dest."
echo "Synced $skill_count ADLC skills into $skills_dest."
echo "Synced $agent_count Codex agents into $agents_dest."
echo "Restart long-lived Codex sessions if they cache skills or agents."
