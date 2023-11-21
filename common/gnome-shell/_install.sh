#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
AR_MODULE="gnome-shell"

log info "Setting misc DE prefereences"
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.desktop.interface monospace-font-name "monospace 11"
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.shell.weather locations "[<(uint32 2, <('Toronto', 'CYTZ', true, [(0.76154532446909495, -1.3857914260834978)], [(0.76212711252195475, -1.3860823201099277)])>)>]"

# Setting keybinds
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/pkill/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/pkill/ name 'Force Quit (Xorg)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/pkill/ command "bash -c \"xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print \$NF}' | xargs xprop -id | awk '/_NET_WM_PID\(CARDINAL\)/{print \$NF}' | xargs kill\""
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/pkill/ binding "<Shift><Control>q"

gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Shift><Super>Right']"
gsettings set org.gnome.settings-daemon.plugins.media-keys play "['<Shift><Super>Down']"
gsettings set org.gnome.settings-daemon.plugins.media-keys previous "['<Shift><Super>Left']"
gsettings set org.gnome.settings-daemon.plugins.media-keys stop "['<Shift><Super>Up']"

gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up "[]"

gsettings set org.gnome.shell disable-extension-version-validation true
