#!/usr/bin/env bash
set -euo pipefail

target="${1:-.}"

if find "$target" -type f \( -name '*.env' -o -name '*.pem' -o -name '*secret*' \) -print | grep -q .; then
  echo "Potential secret-bearing files found under $target" >&2
  exit 1
fi

echo "ADLC security audit helper found no obvious secret-bearing filenames."
