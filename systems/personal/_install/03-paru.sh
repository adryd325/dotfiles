#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="paru"

if [[ "${AR_OS}" == "linux_arch" ]]; then
    log info "Changing paru preferences"
    if [[ -f /etc/paru.conf ]]; then
        [[ ! -e /etc/paru.conf.arbak ]] && sudo cp /etc/paru.conf /etc/paru.conf.arbak
        log silly "Enable BottomUp"
        sudo sed -i "s/^#BottomUp\$/BottomUp/" /etc/paru.conf
        log silly "Enable SudoLoop"
        sudo sed -i "s/^#SudoLoop\$/SudoLoop/" /etc/paru.conf
    fi
fi
