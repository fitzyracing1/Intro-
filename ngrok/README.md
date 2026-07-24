# ngrok endpoint set

- `./up.sh`  — start every tunnel in ngrok.yml
- `./ls.sh`  — table of live tunnels (name / proto / public URL / local port)
- Dashboard: http://localhost:4040

Auth: put `NGROK_AUTHTOKEN=...` in the repo-root `.env` (gitignored).

Notes:
- Free tier = 3 simultaneous endpoints, 1 agent session. Trim the list or upgrade.
- Add `domain: something.ngrok.app` under a tunnel for a stable URL (paid).
- Start a subset: `ngrok start 3xb-api persona-mcp --config ngrok/ngrok.yml`
