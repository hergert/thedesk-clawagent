#!/bin/bash
# Deploys Cloudflare Access secrets
set -e
source "$(dirname "$0")/verify-account.sh"

VAULT="thedeskbot"

echo "🔐 Deploying Cloudflare Access secrets..."

op read "op://$VAULT/cf-access-team-domain/credential" \
  | bunx wrangler secret put CF_ACCESS_TEAM_DOMAIN

op read "op://$VAULT/cf-access-aud/credential" \
  | bunx wrangler secret put CF_ACCESS_AUD

echo "✅ Access secrets deployed"
