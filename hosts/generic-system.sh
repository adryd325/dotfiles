#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../lib/log.sh
[[ "${USER}" = "root" ]] && log error "Do not run as root" && exit 1

../../common/bash/_install.sh
