#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
[ -e "${HOME}/.bashrc" ] && [ ! -e "${HOME}/.bashrc.orig" ] && cp "${HOME}/.bashrc" "${HOME}/.bashrc.orig"
ln -sf "${AR_DIR}/systems/common/bash/bashrc" "${HOME}/.bashrc"
