#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh

../../common/bash/_install.sh
../../common/heckheating/_install.sh "stable" "canary"
