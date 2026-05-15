#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_home="${CODEX_HOME:-$HOME/.codex}"
dest_root="$codex_home/skills"
count=0

mkdir -p "$dest_root"

while IFS= read -r skill_dir; do
  skill_name="$(basename "$skill_dir")"
  dest="$dest_root/$skill_name"

  if [[ -L "$dest" ]]; then
    rm "$dest"
  fi

  mkdir -p "$dest"
  rsync -a --delete "$skill_dir"/ "$dest"/
  echo "Synced Codex ADLC skill: $dest"
  count=$((count + 1))
done < <(find "$repo_root/skills/engineering" -mindepth 1 -maxdepth 1 -type d -name 'adlc-*' | sort)

echo
echo "Synced $count ADLC skills into $dest_root."
echo "Restart long-lived Codex sessions if they need to reload changed skill bodies."
