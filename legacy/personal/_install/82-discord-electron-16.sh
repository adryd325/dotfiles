#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
ar_tmp
AR_MODULE="discord-electron-16"

if [[ "${AR_OS}" = "linux_arch" ]]; then

    [ -e "${AR_TMP}/discord-electron" ] && rm -rf "${AR_TMP}/discord-electron"
    [ ! -e "${HOME}/.local/share" ] && mkdir -p "${HOME}/.local/share"
    mkdir -p "${AR_TMP}/discord-electron"
    workDir="${AR_TMP}/discord-electron"

    cp -r /usr/lib/electron "${workDir}/electron"
    rm -r "${workDir}/electron/resources"
    
    branches=("stable" "ptb" "canary" "development")
    for branch in "${branches[@]}"; do
        AR_LOG_PREFIX="${branch}"
        # fix variables for each branch
        # shellcheck source=../discord/discord-vars.sh
        source "${AR_DIR}/legacy/personal/discord/discord-vars.sh"
        if [[ -d "${HOME}/.local/share/${discordName}" ]]; then
          log info "Replacing existing electron version"
          cp -rf "${workDir}/electron/"* "${HOME}/.local/share/${discordName}"
          cp -rf "${HOME}/.local/share/${discordName}/electron" "${HOME}/.local/share/${discordName}/${discordName}"
          if [[ -f "${HOME}/.local/share/${discordName}/resources/app/package.json" ]] && ! [[ -f "${HOME}/.local/share/${discordName}/resources/app2.asar" ]] ; then
            log info "Fixing HH installation"
            sed -i "s/app.asar/app2.asar/g" "${HOME}/.local/share/${discordName}/resources/app/app_bootstrap/index.js"
            mv "${HOME}/.local/share/${discordName}/resources/app.asar" "${HOME}/.local/share/${discordName}/resources/app2.asar"
          fi
        fi
    done
    AR_LOG_PREFIX=""
fi