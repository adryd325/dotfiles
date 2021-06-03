#!/usr/bin/env bash
touch /var/ar_shutdown
WEBHOOK=https://discord.com/api/webhooks/doot
curl -X POST -H 'Content-Type: application/json' -d "{\"content\":\"shutdown at \`$(date --iso-8601='seconds')\`\"}" $WEBHOOK