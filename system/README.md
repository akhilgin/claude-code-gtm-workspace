# system/

Tooling that supports the workspace.

- `keychain.py`  load secrets from macOS Keychain into the environment
- `migrate_to_keychain.sh`  move secrets out of `.env` into Keychain (dry-run by default)
- `runner.sh`  run a Claude Code slash command headless, for scheduled jobs
- `launchd/`  plist template for scheduling a runner on macOS

Add your own scripts here (CRM clients, ad reports, sync jobs). Have them call `keychain.load_secrets()` rather than reading `.env` for tokens. Anything that writes to an external system should default to dry-run.
