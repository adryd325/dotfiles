#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
[[ "${USER}" = "root" ]] && log error "Do not run as root" && exit 1

../../common/bash/_install.sh
../../oses/linux/discord/_install.sh "stable" "canary"
../../common/heckheating/_install.sh "stable" "canary"
../../oses/linux/discord/wmclass-fix/_install.sh "stable" "canary"
