# About me
<!-- Name, role, what you own. Two or three lines. -->
I am a <role> at <company>. I own <areas, e.g. marketing ops, demand gen, paid ads>.

# How to work with me

## Approach
- Walk me through your approach before doing the work. On bigger tasks, outline the plan and wait for my sign-off.
- ASK before any write to an external system (CRM, ad platforms, Slack, Notion, email, calendar). Reads are fine; writes need explicit approval each time.
- ASK before anything destructive: deleting files, overwriting data, dropping records, force-pushing.
- Default to dry-run. Scripts that change data should print what they would do and require an explicit flag to apply.
- Be direct and concise. Lead with the answer, then explain if needed.
- Keep things simple. No extra abstractions, no new files without a reason.

## Files and folders
- Save working output in `work/YYYY-MM-DD-project-name/`. Create a new dated folder when starting new work.
- Read from `context/`. Never write to it.
- Secrets never go in files. They live in the macOS Keychain; `.env` holds non-secret config only.
- Do not reorganize the folder structure.

# Company
<!-- What the company sells and to whom, in a few lines. -->
- Product: <one-line description>
- ICP: <company size, industry, motion>
- Buyers: <titles>
- Competitors: <names>

# Brand voice
<!-- Replace with your own. Example below. -->
- Direct and clear. Use numbers where you have them.
- Avoid hype words. Lead with the outcome, not the feature.

# Tools
<!-- List what is connected, so Claude knows what it can reach. -->
- CRM: <e.g. Salesforce, via MCP>
- Ads: <e.g. LinkedIn, Meta, Google>
- Analytics: <e.g. GA4>
- Collaboration: <e.g. Slack, Notion, Google Calendar via MCP>
- Scripts: `system/` (Python 3, minimal dependencies)

# Layout
- `context/`  reference material (read-only)
- `system/`   scripts, runners, scheduling
- `work/`     dated project outputs and `journal.md`
- `.claude/commands/`  slash commands
