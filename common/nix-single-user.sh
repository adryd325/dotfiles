#!/usr/bin/env bash
if ! [[ -e "/nix" ]]; then
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
fi