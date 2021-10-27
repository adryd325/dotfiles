#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="fontconfig"

if [ "${AR_OS}" == "linux_arch" ]; then
    if [ ! -e "${HOME}/.config/fontconfig/fonts.conf" ]; then
        log info "Installing fontconfig"
        mkdir -p "${HOME}/.config/fontconfig"
        ln -s "${AR_DIR}/systems/personal/${AR_MODULE}/fonts.conf" "${HOME}/.config/fontconfig/fonts.conf"
    fi
fi
