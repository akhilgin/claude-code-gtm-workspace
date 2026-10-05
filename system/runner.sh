#!/bin/bash
# Run a slash command from .claude/commands/ headless, for launchd or cron.
# Usage: system/runner.sh <command-name> [extra instructions]
# Example: system/runner.sh morning
#
# Scheduled runs cannot answer prompts, so the prompt tells Claude to treat
# every write as "not approved" and to save its output to a file instead.

set -u

CMD="${1:-}"
EXTRA="${2:-}"
if [ -z "$CMD" ]; then
  echo "usage: $0 <command-name> [extra instructions]" >&2
  exit 2
fi

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
cd "$WORKSPACE" || exit 1

OUT_DIR="work/$(date +%Y-%m-%d)-scheduled-$CMD"
LOG="$WORKSPACE/work/runner.log"
mkdir -p "$OUT_DIR" "$(dirname "$LOG")"

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG"; }

# Fail loudly if auth has expired, instead of silently producing nothing.
if ! claude --print -p "say ok" > /dev/null 2>&1; then
  log "ERROR auth check failed for /$CMD. Run 'claude auth login' in a terminal."
  exit 1
fi

PROMPT="Run the /$CMD command from .claude/commands/$CMD.md.
This is an unattended run. Do not write to any external system (CRM, Slack, Notion, email, calendar).
Treat every 'confirm first' step as not approved: list what you would do instead.
Save the final output to $OUT_DIR/output.md. $EXTRA"

for attempt in 1 2; do
  log "start /$CMD attempt $attempt"
  if claude --print -p "$PROMPT" >> "$LOG" 2>&1; then
    log "done /$CMD"
    exit 0
  fi
  log "attempt $attempt failed"
  [ "$attempt" -lt 2 ] && sleep 180
done

log "ERROR /$CMD failed after 2 attempts"
exit 1
