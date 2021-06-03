#!/usr/bin/env bash
source $HOME/.adryd/constants.sh

[ -e "$HOME/.bashrc" ] && [ ! -e "$HOME/.bashrc.arbak" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.arbak"
rm "$HOME/.bashrc"
ln -s "$AR_DIR/systems/personal/040-bash/.bashrc" "$HOME/.bashrc"
