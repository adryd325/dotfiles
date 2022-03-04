#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
export AR_MODULE="thelounge"
[[ "${USER}" != root ]] && log error "Please run as root" && exit 1
cp -f ./configuration.nix /etc/nixos/configuration.nix