#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
AR_MODULE="command-line-tools"

if ! xcode-select -p &> /dev/null; then
    log info "Installing command line tools"
    xcode-select --install
fi
