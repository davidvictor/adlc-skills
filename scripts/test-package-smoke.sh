#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/adlc-package-smoke.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

cd "$repo_root"

pack_json="$tmp_dir/pack.json"
npm --cache "$tmp_dir/npm-cache" pack --pack-destination "$tmp_dir" --json >"$pack_json"
tarball="$(node -e "const fs=require('fs'); const data=JSON.parse(fs.readFileSync(process.argv[1],'utf8')); console.log(require('path').resolve(process.argv[2], data[0].filename));" "$pack_json" "$tmp_dir")"

mkdir -p "$tmp_dir/consumer" "$tmp_dir/project"
npm --cache "$tmp_dir/npm-cache" install "$tarball" --prefix "$tmp_dir/consumer" --no-save >/dev/null

adlc_bin="$tmp_dir/consumer/node_modules/.bin/adlc"
"$adlc_bin" help >/dev/null
"$adlc_bin" agents >/dev/null
"$adlc_bin" init "$tmp_dir/project" --agents codex,claude --mcp filesystem >/dev/null
"$adlc_bin" status "$tmp_dir/project" --strict >/dev/null
"$adlc_bin" workstream create smoke-work "$tmp_dir/project" --lane coordinator >/dev/null
(cd "$tmp_dir/project" && "$adlc_bin" audit-artifacts .adlc --strict >/dev/null)
"$adlc_bin" uninstall "$tmp_dir/project" --agents codex,claude >/dev/null

echo "ADLC package smoke test passed."
