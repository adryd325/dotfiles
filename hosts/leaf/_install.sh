#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh

../../oses/linux/discord/_install.sh "stable" "canary"
../../common/heckheating/_install.sh "stable" "canary"
../../oses/linux/discord/wmclass-fix/_install.sh "stable" "canary"
