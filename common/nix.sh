#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../lib/log.sh
source ../lib/download.sh
source ../lib/temp.sh
AR_MODULE="nix"

if ! [[ -e "/nix" ]]; then
    tempDir=$(mkTemp)
    (
    cd "${tempDir}" || exit $?
    log info "Installing nix"
    download https://nixos.org/nix/install install
    yes | sh install "$@"
    )
fi
