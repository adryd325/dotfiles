#!/usr/bin/env bash
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