#!/usr/bin/env bash
source $HOME/.adryd/constants.sh

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

for module in $AR_DIR/systems/personal/**/install.sh; do
    $module
done