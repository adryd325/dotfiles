#!/bin/bash
# .adryd v5.1
# bash -c "`curl -L adryd.co/install.sh`"
# bash -c "`wget -o- adryd.co/install.sh`"

# --- BEGIN CONSTANTS --- 
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
  AR_OS="$(getKernel)_$(getDistro)"
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
# --- END CONSTANTS ---

ar_const AR_DIR "$HOME/.adryd"

function extract() {
    if [[ -x "$(command -v tar)" ]]; then
        log info "Extracting dotfiles bundle (tar)"
        tar -xf "$1" -C "$AR_TMP"/
        cp -r "$AR_TMP"/dotfiles-master "$AR_DIR"
        [[ -d "$AR_DIR" ]] && return
        log error "Failed extract with tar"
    fi
}

function download() {
    # If we have git
    # TODO: Check if we don't actually have command-line tools
    if [[ -x "$(command -v git)" ]]; then
        if [[ -f "$HOME/.ssh/id_ed25519" ]] || [[ -f "$HOME/.ssh/id_rsa" ]]; then
            log info "Cloning dotfiles repo (git+ssh)"
            git clone "$AR_REMOTE_GIT_SSH" "$AR_DIR" -qq
            [[ -d "$AR_DIR" ]] && return
            log warn "Failed cloning dotfiles repo (git+ssh)"
        fi
        # fall through to https
        log info "Cloning dotfiles repo (git+https)"
        git clone "$AR_REMOTE_GIT_HTTPS" "$AR_DIR" -qq
        [[ -d "$AR_DIR" ]] && return
        log warn "Failed cloning dotfiles repo (git+https)"
    fi

    if [[ -x "$(command -v curl)" ]]; then
        log info "Downloading dotfiles bundle (curl)"
        curl -sSo "$AR_TMP/dotfiles-master.tar" "$AR_REMOTE_HTTPS_TAR"
        [[ -f "$AR_TMP/dotfiles-master.tar" ]] && extract "$AR_TMP/dotfiles-master.tar" && return
        log warn "Failed to download (curl)"
    fi

    if [[ -x "$(command -v wget)" ]]; then
        log info "Downloading dotfiles bundle (wget)"
        wget -qO "$AR_TMP/dotfiles-master.tar" "$AR_REMOTE_HTTPS_TAR"
        [[ -f "$AR_TMP/dotfiles-master.tar" ]] && extract "$AR_TMP/dotfiles-master.tar" && return
        log warn "Failed to download (wget)"
    fi
    
    log error "All download options failed"
}

if [[ -e "$AR_DIR" ]]; then
    log error "$AR_DIR already exists. Please remove it to proceed with the installation."
    exit 1
fi

download || exit 1
log info "Downloaded to $AR_DIR"
sleep 1
"$AR_DIR"/install.sh
