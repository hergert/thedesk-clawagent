#!/bin/bash
# Idempotent 1Password vault setup for OpenClaw
# Safe to run multiple times - only creates missing items
set -e

VAULT="thedeskbot"
SEED="CHANGEME"  # Prefix for placeholder values

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check if item exists in vault
item_exists() {
  op item get "$1" --vault "$VAULT" &>/dev/null
}

# Create item if it doesn't exist
ensure_item() {
  local title="$1"
  local placeholder="$2"

  if item_exists "$title"; then
    echo -e "${GREEN}✓${NC} $title (exists)"
  else
    op item create \
      --category="API Credential" \
      --title="$title" \
      --vault="$VAULT" \
      "credential=${SEED}-${placeholder}" &>/dev/null
    echo -e "${YELLOW}+${NC} $title (created with placeholder)"
  fi
}

echo "🔐 Setting up 1Password vault: $VAULT"
echo ""

# Core secrets (required for deployment)
echo "Core secrets:"
ensure_item "cf-anthropic-api"       "paste-your-anthropic-api-key"
ensure_item "cf-ai-gateway-url"      "paste-your-ai-gateway-url"
ensure_item "cf-gateway-token"       "$(openssl rand -base64 32 | tr -d '=+/' | head -c 32)"

# R2 Storage secrets
echo ""
echo "R2 Storage:"
ensure_item "cf-account-id"          "paste-your-cloudflare-account-id"
ensure_item "cf-access-key-id"       "paste-your-r2-access-key-id"
ensure_item "cf-secret-access-key"   "paste-your-r2-secret-access-key"

# Cloudflare Access (optional)
echo ""
echo "Cloudflare Access (optional):"
ensure_item "cf-access-team-domain"  "yourteam.cloudflareaccess.com"
ensure_item "cf-access-aud"          "paste-your-cf-access-aud"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check for items still containing CHANGEME
echo "⚠️  Items needing real values (contain '$SEED'):"
echo ""

for item in cf-anthropic-api cf-ai-gateway-url cf-gateway-token \
            cf-account-id cf-access-key-id cf-secret-access-key \
            cf-access-team-domain cf-access-aud; do
  if item_exists "$item"; then
    value=$(op read "op://$VAULT/$item/credential" 2>/dev/null || echo "")
    if [[ "$value" == *"$SEED"* ]]; then
      echo -e "  ${RED}•${NC} $item"
    fi
  fi
done

echo ""
echo "Edit these in 1Password app or use:"
echo "  op item edit 'cf-anthropic-api' --vault '$VAULT' 'credential=sk-ant-xxx'"
echo ""
