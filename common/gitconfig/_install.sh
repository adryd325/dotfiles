#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
source ../../lib/realpath.sh
AR_MODULE="gitconfig"

if [[ "${USER}" = "adryd" ]]; then
    log info "Installing gitconfig"
    cp -f "$(realpath ./gitconfig)" "${HOME}/.gitconfig"
fi
