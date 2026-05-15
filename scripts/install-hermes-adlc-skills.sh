#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hermes_home="${HERMES_HOME:-$HOME/.hermes}"

if ! command -v hermes >/dev/null 2>&1; then
  echo "hermes command not found on PATH." >&2
  exit 1
fi

install_into_root() {
  local dest_root="$1"
  local label="$2"
  local count=0

  mkdir -p "$dest_root"

  while IFS= read -r skill_dir; do
    local skill_name
    local dest
    skill_name="$(basename "$skill_dir")"
    dest="$dest_root/$skill_name"

    if [[ -e "$dest" && ! -L "$dest" ]]; then
      local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
      mv "$dest" "$backup"
      echo "Moved existing Hermes skill to $backup"
    fi

    ln -sfn "$skill_dir" "$dest"
    echo "Installed Hermes ADLC skill [$label]: $dest -> $skill_dir"
    count=$((count + 1))
  done < <(find "$repo_root/skills/engineering" -mindepth 1 -maxdepth 1 -type d -name 'adlc-*' | sort)

  echo "Installed $count ADLC skills into $label."
}

install_into_root "$hermes_home/skills/software-development" "global"

if [[ -d "$hermes_home/profiles" ]]; then
  while IFS= read -r profile_dir; do
    profile_name="$(basename "$profile_dir")"
    install_into_root "$profile_dir/skills/software-development" "profile:$profile_name"
  done < <(find "$hermes_home/profiles" -mindepth 1 -maxdepth 1 -type d | sort)
fi

echo
echo "Installed ADLC skills into Hermes global and profile skill homes."
echo
echo "Verify with:"
echo "  hermes skills list | grep adlc-"
echo "  hermes -p sprintrunner skills list | grep adlc-"
echo "  hermes -p sprintbuilder skills list | grep adlc-build"
echo "  hermes -p sprintreviewer skills list | grep adlc-audit"
echo "  hermes -p sprintfixer skills list | grep -E 'adlc-close|adlc-prove'"
