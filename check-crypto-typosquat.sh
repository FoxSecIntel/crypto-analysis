#!/bin/bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  check-crypto-typosquat.sh [brand]

Checks common typo variants for a crypto brand and reports if domains resolve.
Default brand: binance
EOF
}

brand="${1:-binance}"
if [[ "$brand" == "-h" || "$brand" == "--help" ]]; then
  usage; exit 0
fi

# basic variants
variants=(
  "$brand"
  "${brand}x"
  "${brand}1"
  "${brand}-secure"
  "${brand}login"
  "${brand}-wallet"
  "${brand}support"
)

tlds=(com net org io co)

echo "Typosquat check for brand: $brand"

declare -a hits=()
for v in "${variants[@]}"; do
  for t in "${tlds[@]}"; do
    d="${v}.${t}"
    ip="$(dig +short A "$d" | head -n1)"
    if [[ -n "$ip" ]]; then
      age="unknown"
      created="$(whois "$d" 2>/dev/null | awk -F': ' 'tolower($1) ~ /creation date|registered on/ {print $2; exit}')"
      [[ -n "$created" ]] && age="$created"
      echo "[RESOLVES] $d -> $ip | created: $age"
      hits+=("$d")
    fi
  done
done

if [[ ${#hits[@]} -eq 0 ]]; then
  echo "No resolving typo variants found in default set."
else
  echo
  echo "Potential review list (${#hits[@]}):"
  printf ' - %s\n' "${hits[@]}"
fi
