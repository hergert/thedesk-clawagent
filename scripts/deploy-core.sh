#!/bin/bash
# Deploys core secrets (Anthropic + AI Gateway + Gateway Token)
set -e
source "$(dirname "$0")/verify-account.sh"

VAULT="thedeskbot"

echo "🔐 Deploying core secrets (Touch ID required)..."

# Anthropic API key
op read "op://$VAULT/cf-anthropic-api/credential" \
  | bunx wrangler secret put ANTHROPIC_API_KEY

# AI Gateway base URL (enables caching + analytics)
op read "op://$VAULT/cf-ai-gateway-url/credential" \
  | bunx wrangler secret put AI_GATEWAY_BASE_URL

# Gateway token for access control
op read "op://$VAULT/cf-gateway-token/credential" \
  | bunx wrangler secret put MOLTBOT_GATEWAY_TOKEN

echo "✅ Core secrets deployed"
