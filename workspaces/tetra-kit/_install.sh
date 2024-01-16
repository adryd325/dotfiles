#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
AR_MODULE="tetra-kit"

if ! [[ -d "${HOME}/_/tetra-kit" ]]; then
    log info "Installing tetra-kit workspace"
    cp -r . "${HOME}/_/tetra-kit"
    rm "${HOME}/_/tetra-kit/_install.sh"
    (
    cd "${HOME}/_/tetra-kit" || exit $?
    if ! [[ -e ./phys.py ]]; then
        curl https://gitlab.com/larryth/tetra-kit/-/raw/master/phy/pi4dqpsk_rx.grc?inline=false -o phys.grc
    fi

    if ! [[ -d ./tetra-kit-player ]]; then
        git clone https://github.com/sonictruth/tetra-kit-player
        (
            cd tetra-kit-player || exit $?
            npm i
        )
    fi
    chmod +x start.sh
    cat > .envrc <<< "use nix"
    )
fi
