#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="gitconfig"

if [[ "${AR_OS}" = "linux_arch" ]] && [[ "${USER}" = "adryd" ]] && [[ ! -h "${HOME}/.gitconfig" ]]; then
    log info "Installing gitconfig"
    ln -sf "${AR_DIR}/systems/personal/${AR_MODULE}/gitconfig" "${HOME}/.gitconfig"
fi
