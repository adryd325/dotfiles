#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh

../../common/bash/_install.sh

## TODO: Move to individual modules in /oses/macos
if ! xcode-select -p &> /dev/null; then
    log info "Installing command line tools"
    xcode-select --install
fi

if ! [[ -x /usr/local/bin/brew ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

./install-packages.sh
../../common/heckheating/_install.sh "stable" "canary"
