#!/usr/bin/env bash
[[ -z "$AR_DIR" ]] && echo "Please set AR_DIR in your environment" && exit 0; source $AR_DIR/constants.sh
[ -e "$HOME/.bashrc" ] && [ ! -e "$HOME/.bashrc.arbak" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.arbak"
ln -sf "$AR_DIR/systems/common/bash/bashrc" "$HOME/.bashrc"
