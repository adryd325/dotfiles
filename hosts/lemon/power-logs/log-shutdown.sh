#!/usr/bin/env bash
touch /var/ar_shutdown
curl -X POST -k -H 'Content-Type: application/json' -d "{\"content\":\"shutdown at \`$(date --iso-8601='seconds')\`\"}" "${WEBHOOK:?}"