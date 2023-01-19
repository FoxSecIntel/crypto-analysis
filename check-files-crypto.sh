#!/bin/bash

# Set the directory to search
directory="./"

# Set the regular expression for Ethereum addresses
eth_regex="(0x)[a-fA-F0-9]{40}"

# Set the regular expression for Bitcoin addresses
btc_regex="[13][a-km-zA-HJ-NP-Z1-9]{25,34}"

# Search for Ethereum addresses
grep -rE $eth_regex $directory

# Search for Bitcoin addresses
grep -rE $btc_regex $directory
