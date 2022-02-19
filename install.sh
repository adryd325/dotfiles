#!/usr/bin/env bash
# .adryd v5.1
# bash -c "`curl -L adryd.co/install.sh`"
# bash -c "`wget -o- adryd.co/install.sh`"

source ./lib/os.sh
export AR_MODULE="startup"

function askRun() {
    log ask "Detected $1 as preferred install script. Run it? [Y/n]: "
    read -r ask
    if [[ ${ask^^} != "N" ]]; then $1; fi
}

if [[ "${AR_OS}" = "linux_arch" ]] || [[ "${AR_OS}" = "darwin_macos" ]]; then
    if [[ "${AR_OS}" = "linux_arch" ]] && [[ "${USER}" = "root" ]] && [[ "${HOSTNAME}" = "archiso" ]]; then
        askRun ./systems/personal/_arch-install/install.sh
    else
        if [[ "${USER}" != "root" ]]; then
            askRun ./systems/personal/install.sh
        fi
    fi
fi