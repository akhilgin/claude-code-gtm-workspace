#!/bin/bash
# Move secrets from .env into the macOS Keychain.
#
#   system/migrate_to_keychain.sh            dry run: shows what would happen
#   system/migrate_to_keychain.sh --apply    store, verify, then blank the .env values
#
# Safety: .env is only modified after every stored secret reads back from the
# Keychain with the same value. A copy is saved to .env.premigrate first; delete
# it once you have confirmed things work (it contains the secrets).

set -u

APPLY=0
[ "${1:-}" = "--apply" ] && APPLY=1

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/.env"
SERVICE="${KEYCHAIN_SERVICE:-gtm-workspace}"

# Keep in sync with SECRETS in keychain.py.
SECRETS=(CRM_API_TOKEN SLACK_BOT_TOKEN ADS_API_TOKEN ANTHROPIC_API_KEY)

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE not found" >&2
  exit 1
fi

get_value() {
  local v
  v=$(grep -E "^$1=" "$ENV_FILE" | head -1 | cut -d'=' -f2-)
  v="${v%\"}"; v="${v#\"}"; v="${v%\'}"; v="${v#\'}"
  printf '%s' "$v"
}

[ "$APPLY" -eq 1 ] && echo "APPLY mode (service: $SERVICE)" || echo "DRY RUN (service: $SERVICE). Pass --apply to make changes."
echo

FOUND=()
for key in "${SECRETS[@]}"; do
  value="$(get_value "$key")"
  if [ -z "$value" ]; then
    echo "  skip   $key (empty or not in .env)"
    continue
  fi
  FOUND+=("$key")
  if [ "$APPLY" -eq 1 ]; then
    # -U updates an existing entry in place.
    if security add-generic-password -U -s "$SERVICE" -a "$key" -w "$value"; then
      echo "  stored $key"
    else
      echo "  FAILED $key" >&2
    fi
  else
    echo "  would store $key"
  fi
done

if [ "$APPLY" -ne 1 ]; then
  echo
  echo "Nothing changed. Review the list above, then re-run with --apply."
  exit 0
fi

echo
echo "Verifying..."
ALL_OK=1
for key in "${FOUND[@]}"; do
  stored=$(security find-generic-password -s "$SERVICE" -a "$key" -w 2>/dev/null || true)
  if [ "$stored" = "$(get_value "$key")" ] && [ -n "$stored" ]; then
    echo "  ok     $key"
  else
    echo "  BAD    $key" >&2
    ALL_OK=0
  fi
done

if [ "$ALL_OK" -ne 1 ]; then
  echo "Verification failed. .env left unchanged." >&2
  exit 1
fi

cp "$ENV_FILE" "$ENV_FILE.premigrate" && chmod 600 "$ENV_FILE.premigrate"
for key in "${FOUND[@]}"; do
  sed -i '' "s|^${key}=.*|${key}=|" "$ENV_FILE"
done
echo
echo "Done. Secret values blanked in .env (keys kept for reference)."
echo "Backup with old values: $ENV_FILE.premigrate (delete after you confirm scripts work)."
