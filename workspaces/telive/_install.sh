#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
AR_MODULE="telive"

# telive workspace
if ! [[ -d "${HOME}/_/telive" ]]; then
    log info "Installing telive workspace"
    cp -r ./telive "${HOME}/_/telive"
    rm "${HOME}/_/telive/_install.sh"
    (
    cd "${HOME}/_/telive" || exit
    chmod +x start*.sh
    cat > .envrc <<< "use nix"
    )
fi
