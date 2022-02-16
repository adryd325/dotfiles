#!/usr/bin/env bash
if ! [[ -d "/opt/adryd-dotfiles" ]]; then
    sudo git clone https://gitlab.com/adryd/dotfiles /opt/adryd-dotfiles
else
    (
        cd /opt/adryd-dotfiles || return $?
        sudo git pull
    )
fi