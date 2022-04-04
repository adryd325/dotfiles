#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/os.sh
source ../../lib/log.sh
AR_MODULE=alacritty

log info "Installing config"
mkdir -p "${HOME}/.config/alacritty"
cp ./alacritty.yml "${HOME}/.config/alacritty/alacritty.yml"
