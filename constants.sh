#!/usr/bin/env bash

# v6 shims
source "${AR_DIR}"/lib/log.sh
source "${AR_DIR}"/lib/temp.sh
source "${AR_DIR}"/lib/os.sh

function ar_tmp {
    AR_TMP=$(mkTemp)
    export AR_TMP
}

function ar_os {
    if [[ "$(getDistro)" == "arch" ]]; then
        AR_OS="$(getKernel)_arch"
    else
        AR_OS="$(getKernel)_$(getDistro)"
    fi
    export AR_OS
}

function ar_const() {
    # Utility function to make defining env prettier without overwriting
    [[ -z "${!1}" ]] && export "$1"="${*:2}"
}

# Remote URLs
ar_const AR_REMOTE_HTTPS_TAR "https://gitlab.com/adryd/dotfiles/-/archive/master/dotfiles-master.tar"
ar_const AR_REMOTE_GIT_HTTPS "https://gitlab.com/adryd/dotfiles.git"
ar_const AR_REMOTE_GIT_SSH "git@gitlab.com:adryd/dotfiles.git"

function ar_dir() {
    if [[ -z "${AR_DIR}" ]]; then
        function check() {
            if [[ -f "$1"/.manifest ]] && [[ "$(cat "$1"/.manifest)" = "adryd-dotfiles-v6" ]]; then
                cd "${oldPwd}" || exit 1
                export AR_DIR="$1"
                return 0
            fi
            return 1
        }
        local oldPwd=${PWD}
        cd "$(dirname -- "$0")" || exit 1
        while [[ "${PWD}" != '/' ]]; do check "${PWD}" && return 0; cd ..; done
        cd "${oldPwd}" || exit 1
        while [[ "${PWD}" != '/' ]]; do check "${PWD}" && return 0; cd ..; done
        cd "${oldPwd}" || exit 1
        check "${HOME}/.adryd" && return
        check "/root/.adryd" && return
        return 1
    fi
    return 0
}
ar_dir

function ar_splash() {
    if [[ -z "${AR_SPLASH}" ]] && [[ "$0" = "${AR_DIR}"* ]] || [[ "${AR_MODULE}" = "download" ]]; then
        echo -en "\n \x1b[30;44m \x1b[0m .adryd\n \x1b[30;44m \x1b[0m version 6\n\n"
        export AR_SPLASH=1
    fi
}
ar_splash

function ar_local {
    ar_os
    if [[ "${AR_OS}" = "darwin_macos" ]]; then
        ar_const AR_LOCAL "${HOME}/Library/Application\ Support/adryd-dotfiles"
        ar_const AR_CACHE "${HOME}/Library/Caches/adryd-dotfiles"
    else 
        ar_const AR_LOCAL "${HOME}/.config/adryd-dotfiles"
        ar_const AR_CACHE "${HOME}/.cache/adryd-dotfiles"
    fi
}
