#!/bin/bash

source $AR_DIR/constants.sh
source $AR_DIR/lib/logger.sh

[[ ! $AR_SPLASH ]] \
    && echo \
    && echo -e " \x1b[30;44m \x1b[0m .adryd" \
    && echo -e " \x1b[30;44m \x1b[0m version 5" \
    && echo \
    && AR_SPLASH=1

log 0 'install' 'Checking for archiso'
if [[ $HOSTNAME == 'archiso' ]] && [[ $USER == 'root' ]]; then
    log 2 'index' 'Detected archiso. Running Arch install script'
    $AR_DIR/modules/archinstall/index.sh
    log 0 'index' 'Arch install script done, exiting'
    exit 0
fi

log 0 'install' 'Checking for Debian LXC'
cat /etc/os-release | grep "ID=debian" &> /dev/null
if [[ $? -eq 0 ]] && [[ $(systemd-detect-virt) == 'lxc' ]]; then
    if [[ $USER == 'root' ]]; then
        log 2 'index' 'Detected LXC. Running LXC setup script'
        $AR_DIR/extra/lemon/lxcs/install.sh
        log 0 'index' 'LXC install script done'
        exit 0
    else
        log 2 'index' 'Detected LXC. Please run with escalated privelages'
        exit 0
    fi
fi

