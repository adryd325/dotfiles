#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="gpg"

if [[ "${AR_OS}" = "linux_arch" ]]; then
    if [[ -d "${HOME}/.gnupg" ]]; then
        log silly "Fixing permissions"
        chmod 700 "${HOME}/.gnupg"
    fi
    if ! gpg --list-secret-keys | grep "81456AF8007EC29049793AF9B5D2A33C5F203BC7" > /dev/null; then
        if ar_keyring && [[ -n "${AR_KEYRING}" ]]; then
            # Stupid to say exactly where my privkeys are stored, but whatever
            gpg --import "${AR_KEYRING}/gpg/privkey.asc"
        fi
    fi
fi
