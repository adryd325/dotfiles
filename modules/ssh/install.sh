#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
set -eu
source ../../lib.sh
AR_MODULE="ssh"

if [[ ! -e "${HOME}/.ssh/config" ]]; then
    log info "Installing basic ssh config"
    mkdir -p "${HOME}/.ssh"
    ar_install_symlink ./config ${HOME}/.ssh/config
fi
