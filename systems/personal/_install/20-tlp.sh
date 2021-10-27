#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="tlp"

if [[ "${AR_OS}" = "linux_arch" ]] && [[ "${HOSTNAME}" = "popsicle" ]]; then
    log info "Installing tlp config"
    sudo cp "${AR_DIR}/systems/personal/${AR_MODULE}/99-popsicle.conf" "/etc/tlp.d/99-popsicle.conf"
fi