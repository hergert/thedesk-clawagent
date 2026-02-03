#!/bin/bash
# Add any new secret from 1Password to Cloudflare
# Usage: ./scripts/add-secret.sh "cf-item-name" WRANGLER_SECRET_NAME
# All items use "credential" field (API Credential type)
set -e
source "$(dirname "$0")/verify-account.sh"

VAULT="thedeskbot"
ITEM="${1:?Usage: add-secret.sh 'cf-item-name' WRANGLER_SECRET_NAME}"
SECRET_NAME="${2:?Missing Wrangler secret name}"

echo "🔐 Deploying $SECRET_NAME from $VAULT/$ITEM..."

op read "op://$VAULT/$ITEM/credential" \
  | bunx wrangler secret put "$SECRET_NAME"

echo "📦 Redeploying worker..."
bun run deploy
echo "✅ $SECRET_NAME deployed"
