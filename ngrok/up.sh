#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$DIR/../.env" ] && set -a && . "$DIR/../.env" && set +a
exec ngrok start --all --config "$DIR/ngrok.yml"
