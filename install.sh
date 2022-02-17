#!/usr/bin/env bash
# --- BEGIN CONSTANTS --- 
#!/usr/bin/env bash
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

function ar_os() {
    AR_OS_KERNEL="$(uname -s | tr '[:upper:]' '[:lower:]')"
    AR_OS_DISTRO="unk"
    AR_OS="unk"
    export AR_OS_KERNEL
    if [[ "${AR_OS_KERNEL}" = "linux" ]]; then
        # This is what neofetch does, so I feel safe doing the same
        [[ -f /etc/os-release ]] && source /etc/os-release
        AR_OS_DISTRO="$(echo "${ID}" | sed 's/ //g' | tr '[:upper:]' '[:lower:]')"
        AR_OS="${AR_OS_KERNEL}_${AR_OS_DISTRO}"
    fi
    if [[ "${AR_OS_KERNEL}" = "darwin" ]]; then
        AR_OS_DISTRO="macos"
        AR_OS="${AR_OS_KERNEL}_${AR_OS_DISTRO}"
    fi
    export AR_OS_DISTRO
    export AR_OS
}

function ar_tmp() {
    if [[ -z "${AR_TMP}" ]]; then
        local tmpPrefix=""
        if [[ -n "${AR_MODULE}" ]]; then
            tmpPrefix=".${AR_MODULE}"
        fi
        if [[ -x "$(command -v mktemp)" ]]; then
            AR_TMP="$(mktemp -d -t "adryd-dotfiles${tmpPrefix}.XXXXXXXXXX")" 
            export AR_TMP
        else
            for tempDir in "${TMPDIR}" /tmp; do
                if [[ -d "${tempDir}" ]]; then
                    AR_TMP="${tempDir}"/adryd-dotfiles"${tmpPrefix}"."${RANDOM}"
                    export AR_TMP
                    break
                fi
            done
        fi
        if [[ -z "${AR_TMP}" ]]; then
            log error "Could not find temp folder"
            exit 1
        fi
    fi
}

function ar_local {
    ar_os
    if [[ "${AR_KERNEL}" = "darwin" ]]; then
        ar_const AR_LOCAL "${HOME}/Library/Application\ Support/adryd-dotfiles"
        ar_const AR_CACHE "${HOME}/Library/Caches/adryd-dotfiles"
    else 
        ar_const AR_LOCAL "${HOME}/.config/adryd-dotfiles"
        ar_const AR_CACHE "${HOME}/.cache/adryd-dotfiles"
    fi
}

source "${AR_DIR}"/constants-v6.sh
# --- END CONSTANTS ---
ar_os
AR_MODULE="startup"

function askRun() {
    log ask "Detected $1 as preferred install script. Run it? [Y/n]: "
    read -r ask
    if [[ ${ask^^} != "N" ]]; then $1; fi
}

if [[ "$AR_OS" = "linux_arch" ]] || [[ "$AR_OS" = "darwin_macos" ]]; then
    if [[ "$AR_OS" = "linux_arch" ]] && [[ "$USER" = "root" ]] && [[ "$HOSTNAME" = "archiso" ]]; then
        askRun "$AR_DIR"/systems/personal/_arch-install/install.sh
    else
        if [[ "$USER" != "root" ]]; then
            askRun "$AR_DIR"/systems/personal/install.sh
        fi
    fi
fi

if [[ "$AR_OS" = "linux_debian" ]]; then
    if [[ "$USER" = "root" ]]; then
        askRun "$AR_DIR"/systems/server/vms/install.sh
    fi
fi