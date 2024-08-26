#!/bin/bash

# Set CoinGecko API endpoint
API_ENDPOINT="https://api.coingecko.com/api/v3/simple/price"

# Set currency symbol
CURRENCY="eur"

# Set crypto currency symbols
CRYPTO_CURRENCIES=("bitcoin" "ethereum-name-service" "avalanche-2" "cosmos" "polkadot" "dogecoin" "shiba-inu" "usd-coin")

# Set alert thresholds for each coin
declare -A alert_thresholds=( ["bitcoin"]=20000 ["ethereum-name-service"]=15 ["avalanche-2"]=20 ["cosmos"]=4 ["polkadot"]=4 ["dogecoin"]=0.2 ["shiba-inu"]=0.00004 ["usd-coin"]=1)

# Iterate over crypto currency symbols
for symbol in "${CRYPTO_CURRENCIES[@]}"
do
  # Get live price
  response=$(curl -s "$API_ENDPOINT?ids=$symbol&vs_currencies=$CURRENCY")

  # Use jq to extract the price, with proper handling for keys with special characters
  price=$(echo "$response" | jq -r ".[\"$symbol\"].$CURRENCY")

  # Debugging output
  #echo "Response: $response"
  #echo "Price: $price"

  # Check if the price is a valid number
  if [[ $price != null && $price =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    # Print live price
    echo -n "$symbol price: $price $CURRENCY"

    # Check if price exceeds alert threshold for this coin
    if (( $(echo "$price > ${alert_thresholds[$symbol]}" | bc -l) )); then
      printf " \033[1;32mALERT: $symbol price is above ${alert_thresholds[$symbol]} $CURRENCY\033[0m\n"
    else
      printf " \033[1;31mALERT: $symbol price is below ${alert_thresholds[$symbol]} $CURRENCY\033[0m\n"
    fi
  else
    echo "$symbol price: Data not available"
  fi
done
