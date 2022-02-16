#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ./versions.sh
source ../../lib/log.sh
export AR_MODULE="discord-wmclass-fix"

function patchBranch {
    branch=$1
    AR_LOG_PREFIX="${branch}"
    name=$(getDiscordName "${branch}")
    pkgName=$(getDiscordPkgName "${branch}")
    installationDir="${HOME}/.local/share/${name}"

    if [[ -d "${installationDir}" ]]; then
        # TODO: Create a package.json and app bootstrap that loads the real asar in the case
        # hh isnt already installed
        if ! [[ -d "${installationDir}/resources/app" ]] && [[ -x "$(command -v asar)" ]]; then
            log info "Extracting asar"
            asar e "${installationDir}/resources/app.asar" "${installationDir}/resources/app"
        fi
        log info "Patching"
        sed -i "s/discord/${pkgName}/" "${installationDir}/resources/app/package.json"
    fi
}

if [[ $# -gt 0 ]]; then
    for branch in "$@"; do
        if ! isValidBranch "${branch}"; then
            log warn "The branch \"${branch}\" does not exist"
            continue
        fi
        patchBranch "${branch}" &
    done
    wait
else
    for branch in "${DISCORD_BRANCHES[@]}"; do
      patchBranch "${branch}" &
    done
    wait
fi