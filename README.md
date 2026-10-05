# claude-code-gtm-workspace

A template for running GTM and marketing-ops work through Claude Code: a folder layout, a `CLAUDE.md` with working rules, a few slash commands, Keychain-based secrets, and a way to schedule runs on macOS.

## Why

Ops work is mostly small tasks across many tools: check the CRM, pull ad numbers, draft a recap, file a card, clean some records. Each one is quick, but the context switching is not.

Claude Code can do these tasks if it has three things: tool access (MCP servers and your own scripts), context (reference docs and a record of past work), and rules about what it may change. This repo is a starting point for the third part and a tidy way to organize the first two.

It is a template, not a framework. Copy it, delete what you do not need, and edit the rest.

## Layout

    CLAUDE.md             working rules, loaded every session
    context/              reference material, read-only
    system/               scripts, runner, launchd template, keychain helpers
    work/                 dated outputs: work/YYYY-MM-DD-project/, plus journal.md
    .claude/commands/     slash commands

Each folder has a short README.

## Guardrails

- Review before effect. Claude may read freely. Anything that sends, posts, or changes data in an external system needs a shown draft and a yes. Commands mark these steps "confirm first".
- Dry-run by default. Scripts print what they would do and need an explicit flag, like `--apply`, to act.
- Secrets in Keychain. Tokens never live in files. `.env` holds non-secret config only. `system/keychain.py` loads secrets at run time.
- Dated outputs. Every piece of work lands in `work/YYYY-MM-DD-name/` so it can be found, reproduced, and reviewed.
- Read-only context. Reference material is never edited by Claude.
- You are accountable. Read generated code and drafts before you use them.

## Slash commands

- `/morning`  briefing from calendar, Slack, CRM, and ad spend
- `/weekly-recap`  weekly summary from your journal and data sources, with an executive summary
- `/notion-card <description>`  draft a task card, then create it after you confirm
- `/sfdc-dq`  triage a CRM data-quality run (bring your own monitor script)

They use whichever MCP servers you have connected and skip sections they cannot reach. Adjust the sources to match your stack.

## Quick start

1. Click "Use this template" or clone the repo, then rename it.
2. Fill in `CLAUDE.md` (about you, company, ICP, voice, tools).
3. Connect the MCP servers you use (CRM, Slack, calendar, Notion) in Claude Code.
4. Optional, secrets: edit the `SECRETS` list in `system/keychain.py` and `system/migrate_to_keychain.sh`, copy `.env.example` to `.env`, then run `system/migrate_to_keychain.sh` (dry run) and `system/migrate_to_keychain.sh --apply`.
5. Start Claude Code in the repo and run `/morning`.
6. Optional, scheduling: see `system/launchd/README.md`. Schedule read-only commands only.

Requirements: macOS (Keychain and launchd), Claude Code, Python 3.10+.

## Backing up the workspace to a private repo

Your `context/` and `work/` folders hold real data, so they are gitignored. If you want to back up the rest (commands, scripts, `CLAUDE.md`) to a private repo, check before every push:

    git add -A
    git diff --cached --name-only
    git diff --cached | grep -Eio '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}' | sort -u
    git diff --cached | grep -Ei '(token|secret|api[_-]?key|password)[^a-z]*[=:]'

Read the file list. If anything looks like data, a credential, or a personal email address, run `git reset` and fix the ignore rules. Push only when the list is clean. Keep the backup repo private even so.

## What not to commit

- `.env` files, tokens, API keys, service-account JSON, `.mcp.json`
- Anything under `context/` or `work/`
- CRM exports, contact lists, call transcripts, spreadsheets
- Logs and backup files
- Personal Claude Code settings (`.claude/settings.local.json`)

If a secret is committed, rotate it. Removing it from history is not enough.

## License

MIT. See `LICENSE`.
