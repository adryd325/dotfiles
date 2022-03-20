#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?

source ../../lib/log.sh
source ../../lib/temp.sh

source ./extension-list.sh

downloadEndpoint="https://extensions.gnome.org/download-extension/"

tempDir="$(mkTemp)"

function installExtension {
    curl -Lo "${downloadEndpoint}$1.shell-extension.zip"
}

for extension in "${extensions[@]}"; do
    installExtension "${extension}" &
done

wait
