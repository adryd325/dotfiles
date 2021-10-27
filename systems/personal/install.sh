#!/usr/bin/env bash
# shellcheck source=../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh

# sudo keepalive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

for module in "${AR_DIR}"/systems/personal/_install/*.sh; do
    ${module}
done