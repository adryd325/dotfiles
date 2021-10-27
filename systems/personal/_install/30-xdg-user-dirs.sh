#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="xdg-user-dirs"

if [ "${AR_OS}" == "linux_arch" ]; then
    if [ ! -e "${HOME}/.config/user-dirs.dirs" ]; then
        log info "Installing xdg-user-dirs config"
        cp "${AR_DIR}/systems/personal/${AR_MODULE}/user-dirs.dirs" "${HOME}/.config/user-dirs.dirs"
    fi
fi
