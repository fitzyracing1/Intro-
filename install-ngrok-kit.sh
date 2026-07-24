#!/usr/bin/env bash
# fitzyracing1/Intro- → portable copy-paste installer
# Paste this entire script into any terminal / Termux / another project and run it.
# Creates a complete ngrok/ helper set ready for 3xb-api, persona-mcp, etc.

set -euo pipefail

echo "→ Creating ngrok kit in $(pwd)/ngrok ..."

mkdir -p ngrok

# ── ngrok.yml ──────────────────────────────────────────────────────────────
cat > ngrok/ngrok.yml << 'YML'
version: "3"
agent:
  authtoken: ${NGROK_AUTHTOKEN}
tunnels:
  3xb-api:
    proto: http
    addr: 8080
  persona-mcp:
    proto: http
    addr: 8081
  asset-ledger-mcp:
    proto: http
    addr: 8082
  ect-node:
    proto: http
    addr: 8083
  ssh:
    proto: tcp
    addr: 22
YML

# ── up.sh ──────────────────────────────────────────────────────────────────
cat > ngrok/up.sh << 'UP'
#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$DIR/../.env" ] && set -a && . "$DIR/../.env" && set +a
exec ngrok start --all --config "$DIR/ngrok.yml"
UP
chmod +x ngrok/up.sh

# ── ls.sh  (the "ngrok list") ──────────────────────────────────────────────
cat > ngrok/ls.sh << 'LS'
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
LS
chmod +x ngrok/ls.sh

# ── README ─────────────────────────────────────────────────────────────────
cat > ngrok/README.md << 'README'
# ngrok endpoint set

- `./up.sh`  — start every tunnel in ngrok.yml
- `./ls.sh`  — table of live tunnels (name / proto / public URL / local port)
- Dashboard: http://localhost:4040

Auth: put `NGROK_AUTHTOKEN=...` in the repo-root `.env` (gitignored).

Notes:
- Free tier = 3 simultaneous endpoints, 1 agent session. Trim the list or upgrade.
- Add `domain: something.ngrok.app` under a tunnel for a stable URL (paid).
- Start a subset: `ngrok start 3xb-api persona-mcp --config ngrok/ngrok.yml`
README

# ── optional .env template ─────────────────────────────────────────────────
if [ ! -f .env ]; then
  cat > .env.example << 'ENV'
# Copy to .env and fill in
NGROK_AUTHTOKEN=
ENV
  echo "  (created .env.example)"
fi

echo ""
echo "✓ Done. ngrok kit is ready."
echo ""
echo "Next:"
echo "  1. echo 'NGROK_AUTHTOKEN=your_token' > .env"
echo "  2. ./ngrok/up.sh"
echo "  3. ./ngrok/ls.sh          # ← the list you asked for"
echo ""
echo "This entire kit is now local and can be re-copied or moved between apps."
