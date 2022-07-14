#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
AR_MODULE="fontconfig"

if [[ ! -e "${HOME}/.config/fontconfig/fonts.conf" ]]; then
    log info "Installing fontconfig"
    mkdir -p "${HOME}/.config/fontconfig"
    ln -s "$(realpath "./fonts.conf")" "${HOME}/.config/fontconfig/fonts.conf"
fi
