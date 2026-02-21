#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

echo "[1/2] bash -n checks"
for f in ./*.sh; do
  bash -n "$f"
  echo "  OK  $f"
done

if command -v shellcheck >/dev/null 2>&1; then
  echo "[2/2] shellcheck"
  shellcheck ./*.sh
else
  echo "[2/2] shellcheck skipped (not installed)"
fi

echo "QA checks complete."
