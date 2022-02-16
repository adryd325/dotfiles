#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
AR_MODULE="gnome-terminal"

log info "Adding Monokai color scheme"
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
gsettings set org.gnome.Terminal.Legacy.Settings menu-accelerator-enabled false
gsettings set org.gnome.Terminal.ProfilesList default "b1dcc9dd-5262-4d8d-a863-c897e6d979b9"
gsettings set org.gnome.Terminal.ProfilesList list "['b1dcc9dd-5262-4d8d-a863-c897e6d979b9']"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ login-shell true
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ palette "['rgb(30,30,30)', 'rgb(224,97,135)', 'rgb(186,220,124)', 'rgb(245,216,110)', 'rgb(229,152,106)', 'rgb(167,157,239)', 'rgb(157,220,232)', 'rgb(252,252,250)', 'rgb(113,112,114)', 'rgb(224,97,135)', 'rgb(186,220,124)', 'rgb(245,216,110)', 'rgb(229,152,106)', 'rgb(167,157,239)', 'rgb(157,220,232)', 'rgb(252,252,250)']"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ background-color "rgb(30,30,30)"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ foreground-color "rgb(252,252,250)"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ use-theme-colors false
