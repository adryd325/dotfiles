#!/usr/bin/env bash
SAFE='; starting from power loss, kernel panic, or forced shutdown'
[ -e /var/ar_shutdown ] && SAFE='' && rm /var/ar_shutdown
WEBHOOK=https://discord.com/api/webhooks/doot
curl -X POST -H 'Content-Type: application/json' -d "{\"content\":\"startup at \`$(date --iso-8601='seconds')\`$SAFE\"}" $WEBHOOK