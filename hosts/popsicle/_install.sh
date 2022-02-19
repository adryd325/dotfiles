#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh

../../oses/linux/discord/_install.sh "stable" "ptb" "canary" "development"
../../common/heckheating/_install.sh "stable" "canary"
../../oses/archlinux/discord/electron16/_install.sh "canary"
../../oses/linux/discord/wmclass-fix/_install.sh "stable" "ptb" "canary" "development"

