#!/bin/bash
# Deploys ALL secrets and redeploys the worker
set -e
source "$(dirname "$0")/verify-account.sh"

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 Full deployment starting..."
echo ""

"$DIR/deploy-core.sh"
echo ""
"$DIR/deploy-r2.sh"
echo ""

echo "📦 Deploying worker..."
bun run deploy

echo ""
echo "🎉 Full deployment complete!"
echo ""
echo "Access your bot at:"
echo "https://thedesk-clawagent.clearmenu-edge.workers.dev/?token=$(op read 'op://thedeskbot/cf-gateway-token/credential')"
