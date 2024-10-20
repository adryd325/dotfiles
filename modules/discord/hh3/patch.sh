#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
set -eu
source ../../../lib.sh
source ../variables.sh
AR_MODULE="discord hh3 patch"

function patch_branch() {
    branch=$1
    AR_LOG_PREFIX="${branch}"

    binaryPath=$(get_discord_binary_path "${branch}")
    if [[ -x "${binaryPath}" ]]; then
        node "${hhDir}/bin/cli.js" "${binaryPath}" >/dev/null
        log info "Patched branch"
    fi
}

if [[ ! -x $(command -v node) ]]; then
    log error "nodejs isn't installed. Cannot proceed"
    exit 1
fi

if [[ $# -gt 0 ]]; then
    for branch in "$@"; do
        if ! is_valid_discord_branch "${branch}"; then
            log warn "The branch \"${branch}\" does not exist"
            continue
        fi
        patch_branch "${branch}" &
    done
    wait
else
    for branch in "${discordBranches[@]}"; do
        patch_branch "${branch}" &
    done
    wait
fi
