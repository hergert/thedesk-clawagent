#!/bin/bash
# Verifies wrangler is logged into the correct Cloudflare account
# Sources this in other scripts: source "$(dirname "$0")/verify-account.sh"
set -e

VAULT="thedeskbot"

# Get expected account from 1Password
EXPECTED_ACCOUNT=$(op read "op://$VAULT/cf-account-id/credential" 2>/dev/null | tr -d '[:space:]')

if [[ -z "$EXPECTED_ACCOUNT" ]]; then
  echo "❌ Could not read cf-account-id from 1Password"
  exit 1
fi

# Get current wrangler account (handle multiple accounts)
WRANGLER_ACCOUNTS=$(bunx wrangler whoami 2>&1 || true)

if ! echo "$WRANGLER_ACCOUNTS" | grep -q "$EXPECTED_ACCOUNT"; then
  echo "❌ Account mismatch!"
  echo ""
  echo "Expected account: $EXPECTED_ACCOUNT"
  echo ""
  echo "Wrangler is logged into:"
  echo "$WRANGLER_ACCOUNTS" | grep -A1 "Account Name"
  echo ""
  echo "Fix: Run 'bunx wrangler login' and select the correct account"
  exit 1
fi

echo "✅ Account verified: $EXPECTED_ACCOUNT"
