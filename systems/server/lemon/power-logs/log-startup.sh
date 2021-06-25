#!/usr/bin/env bash
safe='; starting from power loss, kernel panic, or forced shutdown'
[ -e /var/ar_shutdown ] && safe='' && rm /var/ar_shutdown
webhook=https://discord.com/api/webhooks/doot
curl -X POST -k -H 'Content-Type: application/json' -d "{\"content\":\"startup at \`$(date --iso-8601='seconds')\`$safe\"}" $webhook