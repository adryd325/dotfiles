#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh

../../common/bash/_install.sh

../../oses/macos/command-line-tools.sh
../../oses/macos/brew.sh
../../common/nix.sh
./install-packages.sh
../../oses/macos/pinentry.sh
../../oses/macos/pnpm.sh
../../common/git-crypt.sh
../../common/heckheating/_install.sh "stable" "canary"
../../common/gitconfig/_install.sh
../../common/vscode/_install.sh
../../oses/macos/virt-viewer/_install.sh
./preferences.sh
