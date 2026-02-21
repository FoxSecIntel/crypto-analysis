#!/bin/bash
set -euo pipefail

usage() {
  echo "Usage: $0 [-d directory]"
}

directory="./"
while getopts ":d:h" opt; do
  case "$opt" in
    d) directory="$OPTARG" ;;
    h) usage; exit 0 ;;
    \?) usage; exit 1 ;;
  esac
done

[[ -d "$directory" ]] || { echo "Error: directory not found: $directory"; exit 1; }

eth_regex='(0x)[a-fA-F0-9]{40}'
btc_regex='[13][a-km-zA-HJ-NP-Z1-9]{25,34}'

echo "Potential Ethereum addresses:"
grep -rE "$eth_regex" "$directory" || true

echo
echo "Potential Bitcoin addresses:"
grep -rE "$btc_regex" "$directory" || true
