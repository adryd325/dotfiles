#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?

source ../../lib/log.sh
source ../../lib/os.sh

../../common/bash/_install.sh
../../common/bash/_install.sh globalInstall

../../oses/archlinux/pacman/_install.sh
../../oses/archlinux/pacman/multilib.sh
../../oses/archlinux/pacman/fcgu.sh
../../oses/archlinux/pacman/hooks/_install.sh
../../oses/archlinux/pacman/aur-builds/_install.sh
../../oses/archlinux/pacman/toronto-mirrorlist/_install.sh

# Sync after repos are added
sudo pacman -Syyu --noconfirm

./install-packages.sh || exit $?
../../common/git-crypt.sh
../../common/nix.sh --daemon
../../oses/archlinux/paru.sh
./thinkpad_acpi.sh
./optimus.sh
./plymouth.sh
../../common/sysctl/_install.sh
../../common/xdg-user-dirs/_install.sh
../../common/mimeapps/_install.sh
../../common/hide-internal-apps/hide-internal-apps.sh
../../common/timesyncd.sh
../../common/gnome-shell/_install.sh
../../common/gnome-terminal/_install.sh
../../common/alacritty/_install.sh
../../common/vscode/_install.sh
../../common/discord/_install.sh "stable" "ptb" "canary" "development"
../../common/heckheating/_install.sh "stable" "canary"
../../common/discord/wmclass-fix.sh "stable" "ptb" "canary" "development"
../../common/flstudio/_install.sh
../../common/firefox/_install.sh
../../oses/archlinux/fontconfig/_install.sh

sudo systemctl enable gdm > /dev/null
sudo systemctl enable cups > /dev/null
sudo systemctl enable touchegg > /dev/null
sudo systemctl enable thermald > /dev/null
sudo systemctl enable auto-cpufreq > /dev/null
sudo systemctl enable libvirtd > /dev/null
sudo systemctl enable systemd-resolved > /dev/null
systemctl --user enable pipewire > /dev/null
systemctl --user enable pipewire-pulse > /dev/null
