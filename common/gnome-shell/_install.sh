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

log info "Setting app-picker layout"
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox-developer-edition.desktop', 'org.gnome.Terminal.desktop', 'discord-canary.desktop']"
gsettings set org.gnome.desktop.app-folders folder-children "['Utilities', 'Games', 'Creativity', 'LibreOffice', 'Chats']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Games/ apps "['steam.desktop', 'multimc.desktop', 'powder-toy.desktop', 'supertuxkart.desktop', 'uk.co.powdertoy.tpt.desktop', 'org.polymc.polymc.desktop']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Games/ name 'Games'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/LibreOffice/ apps "['libreoffice-startcenter.desktop', 'libreoffice-calc.desktop', 'libreoffice-impress.desktop', 'libreoffice-writer.desktop', 'libreoffice-base.desktop', 'libreoffice-draw.desktop', 'libreoffice-math.desktop']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/LibreOffice/ name 'LibreOffice'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Chats/ apps "['discord.desktop', 'telegramdesktop.desktop', 'signal-desktop.desktop', 'org.mumble_voip.mumble.desktop', 'discord-development.desktop', 'discord-ptb.desktop']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Chats/ name 'Chats'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Creativity/ apps "['aseprite.desktop', 'blender.desktop', 'gimp.desktop', 'org.inkscape.Inkscape.desktop', 'net.blockbench.Blockbench.desktop', 'wine-Programs-Image-Line-FL Studio 20.desktop']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Creativity/ name 'Creativity'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ apps "['org.gnome.DiskUtility.desktop', 'org.gnome.eog.desktop', 'org.gnome.Evince.desktop', 'org.gnome.FileRoller.desktop', 'org.gnome.Extensions.desktop', 'org.gnome.Screenshot.desktop', 'org.gnome.tweaks.desktop', 'org.gnome.Totem.desktop', 'org.gnome.Calculator.desktop', 'pavucontrol.desktop', 'org.gnome.baobab.desktop', 'gnome-system-monitor.desktop', 'org.gnome.font-viewer.desktop', 'io.github.seadve.Kooha.desktop', 're.sonny.Junction.desktop', 'com.github.tchx84.Flatseal.desktop', 'piavpn.desktop', 'ca.desrt.dconf-editor.desktop', 'qt5ct.desktop']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ name 'Utilities'

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

#gsettings set org.gnome.shell disable-extension-version-validation true
