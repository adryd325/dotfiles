#!/usr/bin/env bash
source $HOME/.adryd/constants.sh

# sudo keepalive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

for module in $AR_DIR/systems/personal/_install/*.sh; do
    $module
done