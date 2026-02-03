#!/bin/bash
# Deploy browser automation secrets
set -e
source "$(dirname "$0")/verify-account.sh"

VAULT="thedeskbot"

echo "🔐 Deploying browser automation secrets..."

op read "op://$VAULT/cf-cdp-secret/credential" \
  | bunx wrangler secret put CDP_SECRET

op read "op://$VAULT/cf-cdp-worker-url/credential" \
  | bunx wrangler secret put WORKER_URL

echo "📦 Redeploying worker..."
bun run deploy
echo "✅ Browser automation deployed"
