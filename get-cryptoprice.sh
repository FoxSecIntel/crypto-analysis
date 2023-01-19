#!/bin/bash

# Set CoinGecko API endpoint
API_ENDPOINT="https://api.coingecko.com/api/v3/simple/price"

# Set currency symbol
CURRENCY="eur"

# Set crypto currency symbols
CRYPTO_CURRENCIES=("bitcoin" "ethereum" "dogecoin" "cardano")

# Set alert thresholds for each coin
declare -A alert_thresholds=( ["bitcoin"]=10000 ["ethereum"]=800 ["dogecoin"]=0.5 ["cardano"]=2 )

# Iterate over crypto currency symbols
for symbol in "${CRYPTO_CURRENCIES[@]}"
do
  # Get live price
  response=$(curl -s "$API_ENDPOINT?ids=$symbol&vs_currencies=$CURRENCY")
  price=$(echo $response | jq .$symbol.$CURRENCY)

  # Print live price
  echo -n "$symbol price: $price $CURRENCY"

  # Check if price exceeds alert threshold for this coin
  if (( $(echo "$price > ${alert_thresholds[$symbol]}" | bc -l) )); then
    echo -e " \033[1;32mALERT: $symbol price is above ${alert_thresholds[$symbol]} $CURRENCY\033[0m"
  else
    echo
  fi
done
