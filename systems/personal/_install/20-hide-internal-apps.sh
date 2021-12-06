#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="hide-internal-apps"

function hideApp() {
    app="$1"
    if [[ -f "${app}" ]] && ! grep -l "NoDisplay=true" "${app}" > /dev/null; then
        log silly "Hiding ${app} from apps menu"
        echo "NoDisplay=true" | sudo tee -a "${app}" > /dev/null
    fi
}

if [[ "${AR_OS}" = "linux_arch" ]]; then
    # shellcheck source=../hide-internal-apps/application-list.sh
    source "${AR_DIR}"/systems/personal/"${AR_MODULE}"/application-list.sh
    log info "Hiding internal apps"
    for appDir in "${appDirs[@]}"; do
        for app in "${apps[@]}"; do
            hideApp "${appDir}"/"${app}"
        done
        for appGlob in "${appGlobs[@]}"; do 
            for app in "${appDir}"/${appGlob}; do
                hideApp "${app}"
            done
        done
    done
fi