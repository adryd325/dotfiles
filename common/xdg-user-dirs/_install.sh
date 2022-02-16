#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
AR_MODULE="xdg-user-dirs"

if [[ ! -e "${HOME}/.config/user-dirs.dirs" ]]; then
    log info "Installing xdg-user-dirs config"
    cp ./user-dirs.dirs "${HOME}/.config/user-dirs.dirs"
fi