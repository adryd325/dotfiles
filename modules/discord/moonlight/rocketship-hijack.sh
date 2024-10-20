#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
set -eu
source ../../../lib.sh
source ../variables.sh
AR_MODULE="discord moonlight rocketship-install"

electronUrl="https://github.com/moonlight-mod/discord-electron/releases/latest/download/electron.tar.gz"
venmicUrl="https://registry.npmjs.org/@vencord/venmic/-/venmic-6.1.0.tgz"

tempDir=$(ar_mktemp)

(
    log info "Downloading Electron"
    if ! ar_download "${electronUrl}" "${tempDir}/electron.tar.gz"; then
        log error "Failed to download"
        return 1
    fi

    log info "Extracting Electron"
    mkdir "${tempDir}/electron"
    tar -xf "${tempDir}/electron.tar.gz" -C "${tempDir}/electron" || return
) &

(
    log info "Downloading venmic"
    if ! ar_download "${venmicUrl}" "${tempDir}/venmic.tar.gz"; then
        log error "Failed to download"
        return 1
    fi
    log info "Extracting venmic"
    tar -xf "${tempDir}/venmic.tar.gz" -C "${tempDir}" "package/prebuilds/venmic-addon-linux-x64/node-napi-v7.node"
    mv "${tempDir}/package/prebuilds/venmic-addon-linux-x64/node-napi-v7.node" "${tempDir}/venmic.node"
) &

wait

function install_branch {
    branch=$1
    AR_LOG_PREFIX="${branch}"
    installationDir=$(get_discord_installation_path "${branch}")
    binaryName=$(get_discord_binary_name "${branch}")

    log info "Installing"
    cp -r "${tempDir}/electron/"* "${installationDir}"
    cp "${tempDir}/venmic.node" "${installationDir}"
    mv "${installationDir}/electron" "${installationDir}/${binaryName}"
}

if [[ $# -gt 0 ]]; then
    for branch in "$@"; do
        if ! is_valid_discord_branch "${branch}"; then
            log warn "The branch \"${branch}\" does not exist"
            continue
        fi
        install_branch "${branch}" &
    done
    wait
else
    install_branch canary
fi

rm -rf "${tempDir}"
