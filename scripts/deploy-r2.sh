#!/bin/bash
# Deploys R2 storage secrets
set -e
source "$(dirname "$0")/verify-account.sh"

VAULT="thedeskbot"

echo "🔐 Deploying R2 storage secrets..."

op read "op://$VAULT/cf-access-key-id/credential" \
  | bunx wrangler secret put R2_ACCESS_KEY_ID

op read "op://$VAULT/cf-secret-access-key/credential" \
  | bunx wrangler secret put R2_SECRET_ACCESS_KEY

op read "op://$VAULT/cf-account-id/credential" \
  | bunx wrangler secret put CF_ACCOUNT_ID

echo "✅ R2 secrets deployed"
