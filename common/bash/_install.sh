#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
[[ -e "${HOME}/.bashrc" ]] && [[ ! -e "${HOME}/.bashrc.orig" ]] && cp "${HOME}/.bashrc" "${HOME}/.bashrc.orig"
ln -sf "$(pwd)/bashrc" "${HOME}/.bashrc"
