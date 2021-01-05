#!/bin/bash
# .adryd v4.2

source ~/.adryd/constants.sh

[[ ! $AR_SPLASH ]] \
    && echo \
    && echo -e " \x1b[30;44m \x1b[0m .adryd" \
    && echo -e " \x1b[30;44m \x1b[0m version 4.2" \
    && echo \
    && AR_SPLASH=true

source $AR_DIR/lib/logger.sh

log 0 'install' 'Detecting archiso...'
if [[ $HOSTNAME == 'archiso' ]] && [[ $USER == 'root' ]]; then
    log 2 'index' 'Detected archiso. Running Arch install script.'
    $AR_DIR/modules/archinstall/index.sh
    log 0 'index' 'Arch install script done, exiting.'
    exit 0
fi

log 0 'install' 'Detecting LXC...'
cat /etc/os-release | grep "NAME=Fedora" &> /dev/null
if [[ $? -eq 0 ]] && [[ $(systemd-detect-virt) == 'lxc' ]]; then
    log 2 'index' 'Detected LXC. Running LXC setup script.'
    $AR_DIR/modules/ctsetup/install.sh
    log 0 'index' 'LXC install script done. exiting.'
    exit 0
fi