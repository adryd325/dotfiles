#!/usr/bin/env bash
touch /var/ar_shutdown
webhook=https://discord.com/api/webhooks/doot
curl -X POST -k -H 'Content-Type: application/json' -d "{\"content\":\"shutdown at \`$(date --iso-8601='seconds')\`\"}" $webhook