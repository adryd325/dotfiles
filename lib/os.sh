#!/usr/bin/env bash
function getKernel {
    printf %s "$(uname -s | tr '[:upper:]' '[:lower:]')"
}

function getDistro {
    if [[ "$(getKernel)" = "linux" ]] && [[ -f /etc/os-release ]]; then
        source /etc/os-release
        printf %s "$(echo "${ID}" | sed 's/ //g' | tr '[:upper:]' '[:lower:]')"
        return
    fi
    if [[ "$(getKernel)" = "darwin" ]]; then
        printf "macos"
        return
    fi
    printf "unknown"
}
