#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
set -eu
source ../../lib.sh
AR_MODULE="gitconfig"

log info "Installing gitconfig"
ar_install_symlink "./gitconfig" "${HOME}/.gitconfig"

log info "Installing global gitignore"
ar_install_symlink "./gitignore" "${HOME}/.gitignore"
