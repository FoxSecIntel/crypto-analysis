
#!/bin/bash

# List of well-known cryptocurrency exchanges
exchanges=("binance.com" "coinbase.com" "bitstamp.net" "kraken.com" "bitfinex.com" "crypto.com" "huobi.com" "bittrex.com" "bitmex.com")

# File containing malicious IP addresses
malicious_ips_file="malicious_ips.txt"

# Check if file exists
if [ ! -f "$malicious_ips_file" ]; then
  echo "Error: $malicious_ips_file not found"
  exit 1
fi

# Read malicious IP addresses from file
IFS=$'\r\n' GLOBIGNORE='*' command eval  'malicious_ips=($(cat $malicious_ips_file))'

# Iterate over exchanges
for exchange in "${exchanges[@]}"
do
  # Get all IP addresses of the exchange
  ip_addresses=($(host $exchange | grep "has address" | awk '{print $4}'))

  # Iterate over IP addresses
  for ip_address in "${ip_addresses[@]}"
  do
    # Check if the IP address is in the list of malicious IPs
    if [[ " ${malicious_ips[@]} " =~ " ${ip_address} " ]]; then
      echo -e "\033[1;31m$exchange IP address $ip_address is associated with phishing or other malicious activity\033[0m"
    else
 echo -e "$exchange IP address $ip_address is not associated with any known malicious activity"
    fi
  done
done
