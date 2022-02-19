#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh

AR_MODULE="gtk"
ar_os
ar_tmp

if [[ "${AR_OS}" = "linux_arch" ]]; then
  if [[ ! -f "${HOME}/.gtkrc-2.0" ]]; then
    log info "Installing GTK2 config"
    ln -sf "${AR_DIR}/legacy/personal/${AR_MODULE}/gtk2" "${HOME}/.gtkrc-2.0"
  fi
  if [[ ! -f "${HOME}/.config/gtk-3.0/settings.ini" ]]; then
    log info "Installing GTK3 config"
    mkdir -p "${HOME}/.config/gtk-3.0/"
    ln -sf "${AR_DIR}/legacy/personal/${AR_MODULE}/gtk3" "${HOME}/.config/gtk-3.0/settings.ini"
  fi
fi