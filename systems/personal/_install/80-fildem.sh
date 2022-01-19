#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh

AR_MODULE="fildem"
ar_os
ar_tmp

if [[ "${AR_OS}" = "linux_arch" && "this is too finnicky" = "dont install it" ]]; then
  # Install daemon
  workDir="${AR_TMP}"/${AR_MODULE}
  if [[ -d "${workDir}" ]]; then 
      rm -rf "${workDir}" || exit 1
  fi
  log silly "Making workdir"
  mkdir -p "${workDir}"
  oldPwd=$(pwd)
  cd "${workDir}" || exit 1
  log info "Downloading PKGBUILD"
  curl -sSLO https://raw.githubusercontent.com/adryd325/Fildem/master/PKGBUILD
  sed -i "s/pkgname=python3-fildem/pkgname=python3-fildem-local/" ./PKGBUILD
  log info "Compiling and installing"
  # only way to get it to install unattended
  yes | makepkg -si
  cd src/fildem/fildemGMenu@gonza.com || exit 1
  log info "Packaging gnome extension"
  zip -r -q fildemGMenu@gonza.com.shell-extension.zip ./*
  log info "Installing gnome extension"
  gnome-extensions install ./fildemGMenu@gonza.com.shell-extension.zip --force
  cd "${oldPwd}" || exit 1
fi
