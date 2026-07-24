# fitzyracing1/Intro-  →  Copy-Paste Kit

**One block. Paste anywhere. Works between apps.**

Drop this entire file into Termux, a notes app, Obsidian, VS Code on phone, another repo, or even a chat.  
Then copy the sections you need.

---

## 1. Quick one-shot installer (paste this whole block into any terminal)

```bash
#!/usr/bin/env bash
# fitzyracing1/Intro- portable ngrok kit
# Creates ngrok/ folder + scripts + config in current directory
set -euo pipefail

mkdir -p ngrok

cat > ngrok/ngrok.yml << 'EOF'
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
EOF

cat > ngrok/up.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$DIR/../.env" ] && set -a && . "$DIR/../.env" && set +a
exec ngrok start --all --config "$DIR/ngrok.yml"
EOF
chmod +x ngrok/up.sh

cat > ngrok/ls.sh << 'EOF'
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
EOF
chmod +x ngrok/ls.sh

cat > ngrok/README.md << 'EOF'
# ngrok endpoint set

- `./up.sh`  — start every tunnel in ngrok.yml
- `./ls.sh`  — table of live tunnels (name / proto / public URL / local port)
- Dashboard: http://localhost:4040

Auth: put `NGROK_AUTHTOKEN=...` in the repo-root `.env` (gitignored).

Notes:
- Free tier = 3 simultaneous endpoints, 1 agent session. Trim the list or upgrade.
- Add `domain: something.ngrok.app` under a tunnel for a stable URL (paid).
- Start a subset: `ngrok start 3xb-api persona-mcp --config ngrok/ngrok.yml`
EOF

echo "✓ ngrok kit installed in ./ngrok/"
echo "  1. Add NGROK_AUTHTOKEN=... to .env"
echo "  2. ./ngrok/up.sh"
echo "  3. ./ngrok/ls.sh"
```

---

## 2. Individual files (for surgical paste)

### ngrok/ngrok.yml
```yaml
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
```

### ngrok/up.sh
```bash
#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$DIR/../.env" ] && set -a && . "$DIR/../.env" && set +a
exec ngrok start --all --config "$DIR/ngrok.yml"
```

### ngrok/ls.sh  (the "ngrok list")
```bash
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
```

### ngrok/README.md
```markdown
# ngrok endpoint set

- `./up.sh`  — start every tunnel in ngrok.yml
- `./ls.sh`  — table of live tunnels (name / proto / public URL / local port)
- Dashboard: http://localhost:4040

Auth: put `NGROK_AUTHTOKEN=...` in the repo-root `.env` (gitignored).

Notes:
- Free tier = 3 simultaneous endpoints, 1 agent session. Trim the list or upgrade.
- Add `domain: something.ngrok.app` under a tunnel for a stable URL (paid).
- Start a subset: `ngrok start 3xb-api persona-mcp --config ngrok/ngrok.yml`
```

---

## 3. Minimal .env template (paste next to the ngrok/ folder)

```bash
# .env  (never commit this)
NGROK_AUTHTOKEN=your_token_here
```

---

## 4. How to use across apps

**Termux / phone terminal**
1. Paste the big installer block → run it
2. Or create files one by one from the individual sections

**Any other app (notes, Obsidian, iOS Files, VS Code)**
- Keep this whole Markdown file as a living clipboard
- Select only the section you need and paste

**Into another GitHub repo**
- Run the installer inside the target repo
- Or just copy the `ngrok/` folder structure

**Share with yourself later**
- This single Markdown is the entire kit. No need to re-clone Intro- every time.

---

Created from fitzyracing1/Intro- on 2026-07-24  
Ready for phone-first / multi-app workflows.
