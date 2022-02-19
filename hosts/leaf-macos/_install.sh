#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh

../../common/heckheating/_install.sh "stable" "canary"
