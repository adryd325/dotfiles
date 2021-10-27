#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
# disabled for the time being as patch 1441 doesn't apply
ar_os
ar_tmp
AR_MODULE="mutter-performance"

if [[ "${AR_OS}" = "linux_arch" ]]; then
    workDir="${AR_TMP}"/mutter-performance
    if [[ -d "${workDir}" ]]; then 
        rm -rf "${workDir}" || exit 1
    fi
    log silly "Making workdir"
    mkdir -p "${workDir}"
    log info "Cloning PKGBUILD"
    git clone https://aur.archlinux.org/mutter-performance.git "${workDir}" --quiet
    log info "Patching PKGBUILD"
    # change package name
    sed -i "s/pkgname=mutter-performance/pkgname=mutter-performance-local/" "${workDir}"/PKGBUILD
    # fixes FPS issues on Intel iGPU
    sed -i "s/_merge_requests_to_use=()/_merge_requests_to_use=('1441')/" "${workDir}"/PKGBUILD
    # fixes builds failing cause of no dbus or whatever
    sed -i "s/meson test -C build --print-errorlogs//" "${workDir}"/PKGBUILD
    # add 1441-40.3 patch to fix mutter-performance failing to build
    # since the MR targets master
    sed -i "s|pick_mr '1441'|pick_mr '1441' '../1441.patch' 'patch'|" "${workDir}/PKGBUILD"
    cp "${AR_DIR}"/systems/personal/"${AR_MODULE}"/1441-40.3.patch "${workDir}"/1441.patch
    oldPwd=$(pwd)
    cd "${workDir}" || exit 1
    log info "Compiling and installing"
    # only way to get it to install unattended
    yes | makepkg -si
    cd "${oldPwd}" || exit 1
fi
