#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/os.sh

[[ -e "${HOME}/.bashrc" ]] && [[ ! -e "${HOME}/.bashrc.orig" ]] && cp "${HOME}/.bashrc" "${HOME}/.bashrc.orig"
ln -sf "$(realpath "./bashrc")" "${HOME}/.bashrc"

if [[ "$(getDistro)" = "macos" ]]; then
    [[ -e "${HOME}/.zshrc" ]] && [[ ! -e "${HOME}/.zshrc.orig" ]] && cp "${HOME}/.zshrc" "${HOME}/.zshrc.orig"
    ln -sf "$(realpath "./bashrc")" "${HOME}/.zshrc"
fi
