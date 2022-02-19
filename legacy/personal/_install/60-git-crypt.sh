#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="git-crypt"

if [[ "${AR_OS}" = "linux_arch" ]]; then
    git-crypt unlock "${AR_DIR}"
fi