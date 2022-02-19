#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="ca-certificates"

if [[ "${AR_OS}" = "linux_arch" ]] && [[ "${USER}" = "adryd" ]]; then
    log info "Trusting internal CA"
    sudo trust anchor --store "${AR_DIR}"/systems/common/"${AR_MODULE}"/adryd-root-ca.pem
fi