# crypto-analysis

Practical scripts for crypto-related security triage.

## Included tools

- `get-cryptoprice.sh` — live price checks with threshold alerts
- `check-exchange-cert.sh` — TLS certificate checks for major exchanges
- `check-exchange-ip.sh` — exchange IP checks against a local blocklist
- `check-files-crypto.sh` — detect potential BTC/ETH wallet strings in files
- `check-wallet-risk.sh` — validate wallet formats + best-effort activity enrichment
- `check-crypto-typosquat.sh` — scan common typo-domain variants for crypto brands
- `qa_check.sh` — syntax + optional shellcheck checks

## Usage

```bash
./get-cryptoprice.sh
./check-exchange-cert.sh
./check-exchange-ip.sh -f malicious_ips.txt
./check-files-crypto.sh -d /path/to/search
./check-wallet-risk.sh 0x0000000000000000000000000000000000000000
./check-wallet-risk.sh -f wallets.txt --json
./check-crypto-typosquat.sh binance
./qa_check.sh
```

## Notes

- Scripts are for defensive/authorized use.
- Network calls can be rate-limited; scripts handle common failures where possible.
- `check-exchange-ip.sh` requires an IP list file (one IP per line).
