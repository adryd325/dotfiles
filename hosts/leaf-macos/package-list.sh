#!/usr/bin/env bash
export brewTaps=("homebrew/cask-versions" "homebrew/cask-fonts" "jeffreywildman/virt-manager")
export brewPackages=(
    # other cli tools will be installed by nix
    "git"
    "bash"
    "nodejs"
    "mas"

    # Utilities
    "apptrap" # apptrap always first cask
    "blockblock"
    "keka"
    "knockknock"
    "lulu"
    "netiquette"
    "suspicious-package"
    "virt-viewer"

    # Base apps
    "discord"
    "discord-canary"
    "firefox"
    "iterm2"
    "visual-studio-code"
    "1password"

    # Extra
    "affinity-designer-beta"
    "tor-browser"
    "font-cascadia-code"
)

export masPackages=(
    # I think one of these is pixelmator and the other is apple configurator 2
    "407963104"
    "1037126344"
)