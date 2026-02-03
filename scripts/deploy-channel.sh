#!/bin/bash
# Deploy a chat channel secret
# Usage: ./scripts/deploy-channel.sh telegram|discord|slack
set -e
source "$(dirname "$0")/verify-account.sh"

VAULT="thedeskbot"
CHANNEL="${1:?Usage: deploy-channel.sh telegram|discord|slack}"

case "$CHANNEL" in
  telegram)
    echo "🔐 Deploying Telegram bot token..."
    op read "op://$VAULT/cf-telegram-bot/credential" \
      | bunx wrangler secret put TELEGRAM_BOT_TOKEN
    ;;
  discord)
    echo "🔐 Deploying Discord bot token..."
    op read "op://$VAULT/cf-discord-bot/credential" \
      | bunx wrangler secret put DISCORD_BOT_TOKEN
    ;;
  slack)
    echo "🔐 Deploying Slack tokens..."
    op read "op://$VAULT/cf-slack-bot-token/credential" \
      | bunx wrangler secret put SLACK_BOT_TOKEN
    op read "op://$VAULT/cf-slack-app-token/credential" \
      | bunx wrangler secret put SLACK_APP_TOKEN
    ;;
  *)
    echo "❌ Unknown channel: $CHANNEL"
    echo "Usage: deploy-channel.sh telegram|discord|slack"
    exit 1
    ;;
esac

echo "📦 Redeploying worker..."
bun run deploy
echo "✅ $CHANNEL channel deployed"
