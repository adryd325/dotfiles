#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
export AR_MODULE="jump"
[[ "${USER}" != root ]] && log error "Please run as root" && exit 1
ln -sf /bin/sh /bin/bash
cp -f ./configuration.nix /etc/nixos/configuration.nix

log tell "You must create /etc/nixos/discordWebhook.nix and /etc/nixos/users.nix"

if ! [[ -f /etc/nixos/discordWebhook.nix ]]; then
    echo -e "{\n\n}" > /etc/nixos/discordWebhook.nix
fi

if ! [[ -f /etc/nixos/users.nix ]]; then
    echo -e "{\n\n}" > /etc/nixos/users.nix
fi