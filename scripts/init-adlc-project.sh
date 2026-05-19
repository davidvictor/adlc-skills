#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_dir="${1:-$PWD}"
adlc_dir="$target_dir/.adlc"

if [[ ! -d "$target_dir" ]]; then
  echo "Target directory does not exist: $target_dir" >&2
  exit 1
fi

mkdir -p \
  "$adlc_dir/plans" \
  "$adlc_dir/fixes" \
  "$adlc_dir/patches" \
  "$adlc_dir/skill-context" \
  "$adlc_dir/qa" \
  "$adlc_dir/rules"

copy_if_missing() {
  local source="$1"
  local dest="$2"
  if [[ -f "$dest" ]]; then
    echo "Preserved existing: $dest"
    return
  fi
  cp "$source" "$dest"
  echo "Created: $dest"
}

write_if_missing() {
  local dest="$1"
  local title="$2"
  if [[ -f "$dest" ]]; then
    echo "Preserved existing: $dest"
    return
  fi
  {
    printf "# %s\n\n" "$title"
    printf "Status: draft\n\n"
    printf "Update this file with repo-specific ADLC context before relying on plans or gates.\n"
  } > "$dest"
  echo "Created: $dest"
}

copy_if_missing "$repo_root/templates/adlc/config.yaml" "$adlc_dir/config.yaml"
write_if_missing "$adlc_dir/DESCRIPTION.md" "Project Description"
write_if_missing "$adlc_dir/ARCHITECTURE.md" "Architecture"
write_if_missing "$adlc_dir/RULES.md" "Rules"

echo
echo "ADLC initialized at $adlc_dir"
echo "Next: run adlc-explore, adlc-grounded, or adlc-plan from the target project."
