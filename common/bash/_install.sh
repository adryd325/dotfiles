#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/os.sh
source ../../lib/realpath.sh

if [[ -d "/opt/adryd-dotfiles" ]] && [[ "$1" == "globalInstall" ]]; then
    [[ -e "/root/.bashrc" ]] && [[ ! -e "/root/.bashrc.orig" ]] && cp "/root/bashrc" "/root/.bashrc.orig"
    sudo cp -f /opt/adryd-dotfiles/common/bash/bashrc "/root/.bashrc"

    mapfile -t IDs <<< "$(cut -d ":" -f3 /etc/passwd)"
    mapfile -t homeFolders <<< "$(cut -d ":" -f6 /etc/passwd)"
    count=$(wc -l /etc/passwd | cut -d " " -f1)

    # for each manually created user
    for i in $(seq "${count}"); do
        if [[ ${IDs[${i}]} -gt 999 ]] && [[ ${IDs[${i}]} -lt 2000 ]]; then
            home="${homeFolders[${i}]}"
            [[ -e "${home}/.bashrc" ]] && [[ ! -e "${home}/.bashrc.orig" ]] && cp "${home}/.bashrc" "${home}/.bashrc.orig"
            # no -f to not override local installation
            sudo cp /opt/adryd-dotfiles/common/bash/bashrc "${home}/.bashrc" 2> /dev/null
        fi
    done
else
    [[ -e "${HOME}/.bashrc" ]] && [[ ! -e "${HOME}/.bashrc.orig" ]] && cp "${HOME}/.bashrc" "${HOME}/.bashrc.orig"
    ln -sf "$(realpath "./bashrc")" "${HOME}/.bashrc"
fi
