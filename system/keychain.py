"""
Load secrets from the macOS Keychain into os.environ.

Each secret is a generic-password entry:
    service:  KEYCHAIN_SERVICE (env var, default "gtm-workspace")
    account:  the variable name, e.g. "CRM_API_TOKEN"

Usage in a script:
    from keychain import load_secrets
    load_secrets(".env")   # keychain first, then non-secret config from .env

Values already present in the environment are never overwritten, and Keychain
values win over .env. Edit SECRETS to list the variables your scripts need.
"""

import os
import subprocess

SECRETS = [
    "CRM_API_TOKEN",
    "SLACK_BOT_TOKEN",
    "ADS_API_TOKEN",
    "ANTHROPIC_API_KEY",
]


def service_name() -> str:
    return os.environ.get("KEYCHAIN_SERVICE", "gtm-workspace")


def _keychain_get(key: str) -> str | None:
    """Read one secret from the Keychain. Returns None if missing."""
    try:
        result = subprocess.run(
            ["security", "find-generic-password", "-s", service_name(), "-a", key, "-w"],
            capture_output=True,
            text=True,
        )
    except OSError:
        return None  # not macOS, or `security` not available
    if result.returncode == 0:
        return result.stdout.strip() or None
    return None


def inject_secrets() -> None:
    """Set every known secret from the Keychain into os.environ."""
    for key in SECRETS:
        if os.environ.get(key):
            continue
        value = _keychain_get(key)
        if value:
            os.environ[key] = value


def _parse_env_file(path: str) -> None:
    """Minimal .env parser, used when python-dotenv is not installed."""
    try:
        with open(path) as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#") or "=" not in line:
                    continue
                key, _, value = line.partition("=")
                key = key.strip()
                value = value.strip().strip('"').strip("'")
                if key and not os.environ.get(key):
                    os.environ[key] = value
    except OSError:
        pass


def load_secrets(env_path: str | None = None) -> None:
    """Keychain secrets first, then non-secret config from env_path."""
    inject_secrets()
    if env_path:
        try:
            from dotenv import load_dotenv

            load_dotenv(env_path, override=False)
        except ImportError:
            _parse_env_file(env_path)


if __name__ == "__main__":
    # Report which secrets are available, without printing their values.
    inject_secrets()
    for k in SECRETS:
        print(f"{'set    ' if os.environ.get(k) else 'missing'}  {k}")
