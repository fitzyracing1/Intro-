#!/usr/bin/env bash
set -euo pipefail
API="${NGROK_API:-http://localhost:4040/api/tunnels}"
if ! curl -sf "$API" >/dev/null; then
  echo "ngrok agent not running (no API on 4040). Start it with ngrok/up.sh" >&2
  exit 1
fi
curl -s "$API" | jq -r '
  ["NAME","PROTO","PUBLIC URL","UPSTREAM"],
  (.tunnels[] | [.name, .proto, .public_url, .config.addr])
  | @tsv' | column -t -s $'\t'
