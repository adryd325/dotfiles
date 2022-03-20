#!/usr/bin/env bash
details='; starting from power loss, kernel panic, or forced shutdown'
[[ -e /var/ar_shutdown ]] && details='' && rm /var/ar_shutdown
curl -X POST -k -H 'Content-Type: application/json' -d "{\"content\":\"startup at \`$(date --iso-8601='seconds')\`${details}\"}" "${WEBHOOK:?}"
