#!/bin/bash
set -euo pipefail

usage() {
  echo "Usage: $0 -f malicious_ips.txt"
}

malicious_ips_file=""
while getopts ":f:h" opt; do
  case "$opt" in
    f) malicious_ips_file="$OPTARG" ;;
    h) usage; exit 0 ;;
    \?) usage; exit 1 ;;
  esac
done

[[ -n "$malicious_ips_file" ]] || { usage; exit 1; }
[[ -f "$malicious_ips_file" ]] || { echo "Error: $malicious_ips_file not found"; exit 1; }

exchanges=("binance.com" "coinbase.com" "bitstamp.net" "kraken.com" "bitfinex.com" "crypto.com" "huobi.com" "bittrex.com" "bitmex.com")
mapfile -t malicious_ips < <(grep -Eo '^([0-9]{1,3}\.){3}[0-9]{1,3}$' "$malicious_ips_file" | sort -u)

for exchange in "${exchanges[@]}"; do
  mapfile -t ip_addresses < <(host "$exchange" 2>/dev/null | awk '/has address/{print $4}' | sort -u)
  if [[ ${#ip_addresses[@]} -eq 0 ]]; then
    echo "$exchange: no IPv4 addresses resolved"
    continue
  fi

  for ip_address in "${ip_addresses[@]}"; do
    if printf '%s\n' "${malicious_ips[@]}" | grep -qx "$ip_address"; then
      echo -e "\033[1;31m$exchange IP $ip_address is in malicious list\033[0m"
    else
      echo "$exchange IP $ip_address not in malicious list"
    fi
  done
done
