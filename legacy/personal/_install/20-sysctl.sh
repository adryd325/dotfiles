#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="sysctl"

if [[ "${AR_OS}" = "linux_arch" ]]; then
    log info "Installing sysrq config"
    sudo cp -f "${AR_DIR}"/systems/personal/"${AR_MODULE}"/99-sysrq.conf /etc/sysctl.d/99-sysrq.conf
fi