#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
ar_tmp
AR_MODULE="discord-wmclass-fix"

# THIS LITERALLY ONLY WORKS CAUSE OF HH...
if [[ "${AR_OS}" = "linux_arch" ]]; then
    branches=("stable" "ptb" "canary" "development")
    for branch in "${branches[@]}"; do
        AR_LOG_PREFIX="${branch}"
        # fix variables for each branch
        # shellcheck source=../discord/discord-vars.sh
        source "${AR_DIR}/systems/personal/discord/discord-vars.sh"
        log info "Fixing WM_CLASS"
        if [[ -f "${HOME}/.local/share/${discordName}/resources/app/package.json" ]]; then
            sed -i "s/discord/${discordLowercase}/" "${HOME}/.local/share/${discordName}/resources/app/package.json"
        fi
    done
    AR_LOG_PREFIX=""
fi