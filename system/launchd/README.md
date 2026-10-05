# launchd/

`com.example.gtm-runner.plist.template` schedules `system/runner.sh` on macOS.

Setup:

1. Copy the template to `~/Library/LaunchAgents/com.example.gtm-morning.plist`.
2. Replace the `__PLACEHOLDERS__` (label, workspace path, command name, hour, minute).
3. Check it: `plutil -lint ~/Library/LaunchAgents/com.example.gtm-morning.plist`
4. Load it: `launchctl load ~/Library/LaunchAgents/com.example.gtm-morning.plist`
5. Test once without waiting: `launchctl start com.example.gtm-morning`

Auth in headless runs:
- A launchd job does not run in your interactive shell. Make sure `claude` is on the PATH set in the plist or the runner.
- Claude Code login can expire. `runner.sh` does a cheap auth check first and exits loudly if it fails; fix with `claude auth login` in a terminal.
- If you use an API key instead of a login, read it from Keychain inside the runner, never write it into the plist.
- Keychain access from a background job may need the login keychain to be unlocked (you must be logged in).
- Scheduled runs cannot answer prompts. Only schedule read-only commands, or have them write a draft file for you to review.
