#!/bin/bash
set -euo pipefail

exchanges=("binance.com" "coinbase.com" "bitstamp.net" "kraken.com" "bitfinex.com" "crypto.com")

for exchange in "${exchanges[@]}"; do
  cert_output="$(echo | openssl s_client -servername "$exchange" -connect "$exchange:443" 2>/dev/null | openssl x509 -noout -dates -subject -issuer 2>/dev/null || true)"

  if [[ -z "$cert_output" ]]; then
    echo -e "\033[1;31m$exchange: certificate fetch failed\033[0m"
    echo
    continue
  fi

  not_after="$(echo "$cert_output" | awk -F= '/^notAfter=/{print $2}')"
  issuer="$(echo "$cert_output" | awk -F= '/^issuer=/{print $2}')"
  subject="$(echo "$cert_output" | awk -F= '/^subject=/{print $2}')"

  echo -e "\033[1;32m$exchange SSL/TLS certificate retrieved\033[0m"
  echo "Expiration date: ${not_after:-unknown}"
  echo "Issuer: ${issuer:-unknown}"
  echo "Subject: ${subject:-unknown}"
  echo

done
