#!/usr/bin/env bash
# =============================================================================
# Build + deploy the landing page to the Pi.
#
# Usage:    ./deploy.sh
# Target:   cristian@192.168.1.100:/var/www/landing/
# Hostname: https://www.edgesecura.dev
#
# Apex (edgesecura.dev without www) is NOT served by this vhost — the
# wildcard cert at /etc/letsencrypt/live/edgesecura.dev/ covers
# *.edgesecura.dev only. Add an apex cert + a separate vhost if you want
# to serve there too.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${LANDING_TARGET:-cristian@192.168.1.100:/var/www/landing/}"

echo "→ build"
( cd "$SCRIPT_DIR" && npm run build )

echo "→ rsync to $TARGET"
rsync -av --delete \
    --exclude='.DS_Store' \
    "$SCRIPT_DIR/dist/" "$TARGET"

echo
echo "Deployed."
echo "Verify: curl -sI https://www.edgesecura.dev/"
