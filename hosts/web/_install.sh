#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
export AR_MODULE="web"
[[ "${USER}" != root ]] && log error "Please run as root" && exit 1
ln -sf /bin/sh /bin/bash
cp -f ./configuration.nix /etc/nixos/configuration.nix
