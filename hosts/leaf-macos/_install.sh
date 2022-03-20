#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh

../../common/bash/_install.sh

../../oses/macos/command-line-tools.sh
../../oses/macos/brew.sh
../../common/nix.sh
./install-packages.sh
../../oses/macos/pnpm.sh
../../common/heckheating/_install.sh "stable" "canary"
../../oses/macos/virt-viewer/_install.sh
