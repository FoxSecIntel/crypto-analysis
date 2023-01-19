#!/bin/bash

# List of well-known cryptocurrency exchanges
exchanges=("binance.com" "coinbase.com" "bitstamp.net" "kraken.com" "bitfinex.com" "crypto..com")

# Iterate over exchanges
for exchange in "${exchanges[@]}"
do
  # Get SSL/TLS certificate information
  certificate_info=$(echo | openssl s_client -connect $exchange:443 2>/dev/null | openssl x509 -noout -dates -subject -issuer)

  # Check if the certificate is valid
  if echo $certificate_info | grep -q "notAfter"; then
    # Extract expiration date
    expiration_date=$(echo $certificate_info | grep "notAfter" | cut -d "=" -f 2)

    # Extract issuer and subject
    issuer=$(echo $certificate_info | grep "issuer" | cut -d "=" -f 2)
    subject=$(echo $certificate_info | grep "subject" | cut -d "=" -f 2)

    # Print certificate information
    echo -e "\033[1;32m$exchange SSL/TLS certificate is valid\033[0m"
    echo "Expiration date: $expiration_date"
    echo "Issuer: $issuer"
    echo "Subject: $subject"
  else
    echo -e "\033[1;31m$exchange SSL/TLS certificate is not valid\033[0m"
  fi
  echo ""
done
