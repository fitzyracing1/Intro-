# Intro-

Portable ngrok helper set for phone-first / multi-app workflows.

## Copy-paste between apps

The whole point of this repo is that you never have to re-clone it.

**Fastest path:**

1. Open [`COPY-PASTE-NGROK-KIT.md`](COPY-PASTE-NGROK-KIT.md)
2. Copy the big installer block (or any individual file)
3. Paste it into Termux, another project, notes, Obsidian, VS Code on phone, etc.

Or just grab the self-installing script:

```bash
curl -sL https://raw.githubusercontent.com/fitzyracing1/Intro-/main/install-ngrok-kit.sh | bash
```

(or copy the contents of `install-ngrok-kit.sh` and paste it)

## What you get

```
ngrok/
├── ngrok.yml     # tunnels for 3xb-api, persona-mcp, asset-ledger-mcp, ect-node, ssh
├── up.sh         # start all tunnels
├── ls.sh         # clean table of live tunnels  ← "ngrok list"
└── README.md
```

## Usage once installed

```bash
echo 'NGROK_AUTHTOKEN=...' > .env
./ngrok/up.sh
./ngrok/ls.sh
```

Free tier = 3 simultaneous endpoints. Edit `ngrok.yml` to trim if needed.

## Plans

This project is free, and its license stays as is. Support it through [GitHub Sponsors](https://github.com/sponsors/fitzyracing1):

- **Free**: use the code, community support.
- **Pro ($49/month)**: priority issues and support.
- **Team ($199/month)**: priority support for your team plus early access.
