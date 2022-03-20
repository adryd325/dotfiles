#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh

log info "Installing mimeapps list"
cp ./mimeapps.list "${HOME}/.config/mimeapps.list" 2>/dev/null
