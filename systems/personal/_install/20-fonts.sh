#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os

AR_MODULE="fonts"
pkglist=("ttf-recursive-code-local" "otf-inter-local")

if [[ "${AR_OS}" = "linux_arch" ]]; then
    for pkg in "${pkglist[@]}"; do
        log info "Building and installing ${pkg}"
        cd "${AR_DIR}"/systems/personal/"${AR_MODULE}"/"${pkg}" || continue;
        # need to pipe yes for no confirm
        # TODO: use pacman -U
        yes | makepkg -si
    done
fi
