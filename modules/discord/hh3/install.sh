#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
set -eu
source ../../../lib.sh
source ../variables.sh
AR_MODULE="discord hh3 install"

# Clone the repo if we don't have it, and if we might have keys
if [[ ! -d "${hhDir}" ]] && [[ -e "${HOME}/.ssh" ]]; then
    log info "Cloning hh3"
    if ! git clone gitolite3@git.coolmathgames.tech:/hh3.git "${hhDir}" --quiet; then
        log error "Failed to clone HH3, likely a permission issue"
        exit 1
    fi
else
    log info "Pulling latest changes"
    (
        cd "${hhDir}" || exit 1
        git pull
    )
fi

if [[ ! -e "${hhConfigDir}" ]]; then
    log info "Linking config folder"
    if [[ "$(ar_get_distro)" == "macos" ]]; then
        ar_install_symlink "./macos" "${hhConfigDir}"
    else
        ar_install_symlink "./linux" "${hhConfigDir}"
    fi
fi

(
    cd "${hhDir}" || exit $?
    log info "Installing dependencies"
    pnpm -r --workspace-concurrency=1 exec -- pnpm i --shamefully-hoist
    cd "${hhDir}/web" || exit $?
    log info "Building webextension"
    node buildExtension.js &>/dev/null
)
