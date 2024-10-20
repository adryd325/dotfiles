#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
set -eu
source ../../lib.sh
AR_MODULE="discord linux-install"

../../modules/discord/linux-install.sh canary stable &
../../modules/discord/moonlight/install.sh &
../../modules/discord/hh3/install.sh &
wait
../../modules/discord/moonlight/rocketship-hijack.sh canary
../../modules/discord/moonlight/patch.sh canary
