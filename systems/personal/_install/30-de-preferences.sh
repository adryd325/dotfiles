#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="de-preferences"

if [ "${AR_OS}" == "linux_arch" ]; then
    log info "Writing misc dconf preferences"
    
    # Terminal
    gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
    gsettings set org.gnome.Terminal.Legacy.Settings menu-accelerator-enabled false
    gsettings set org.gnome.Terminal.ProfilesList default "b1dcc9dd-5262-4d8d-a863-c897e6d979b9"
    gsettings set org.gnome.Terminal.ProfilesList list "['b1dcc9dd-5262-4d8d-a863-c897e6d979b9']"
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ login-shell true
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ palette "['rgb(30,30,30)', 'rgb(224,97,135)', 'rgb(186,220,124)', 'rgb(245,216,110)', 'rgb(229,152,106)', 'rgb(167,157,239)', 'rgb(157,220,232)', 'rgb(252,252,250)', 'rgb(113,112,114)', 'rgb(224,97,135)', 'rgb(186,220,124)', 'rgb(245,216,110)', 'rgb(229,152,106)', 'rgb(167,157,239)', 'rgb(157,220,232)', 'rgb(252,252,250)']"
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ background-color "rgb(30,30,30)"
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ foreground-color "rgb(252,252,250)"
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ use-theme-colors false

    gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
    gsettings set org.gnome.desktop.privacy remove-old-temp-files true
    gsettings set org.gnome.desktop.privacy remove-old-trash-files true
    gsettings set org.gnome.desktop.interface monospace-font-name "monospace 11"
    gsettings set org.gnome.mutter center-new-windows true
    gsettings set org.gnome.shell.weather locations "[<(uint32 2, <('Toronto', 'CYTZ', true, [(0.76154532446909495, -1.3857914260834978)], [(0.76212711252195475, -1.3860823201099277)])>)>]"
    
    # Shell
    gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox-developer-edition.desktop', 'org.gnome.Terminal.desktop', 'discord-canary.desktop']"
    gsettings set org.gnome.shell app-picker-layout "[{'1password.desktop': <{'position': <0>}>, 'org.gnome.Calendar.desktop': <{'position': <1>}>, 'io.github.celluloid_player.Celluloid.desktop': <{'position': <2>}>, 'Chats': <{'position': <3>}>, 'chromium.desktop': <{'position': <4>}>, 'Cider.desktop': <{'position': <5>}>, 'org.gnome.Contacts.desktop': <{'position': <6>}>, 'com.github.wwmm.easyeffects.desktop': <{'position': <7>}>, 'io.github.quodlibet.ExFalso.desktop': <{'position': <8>}>, 'de.haeckerfelix.Fragments.desktop': <{'position': <9>}>, 'Games': <{'position': <10>}>, 'org.gnome.Geary.desktop': <{'position': <11>}>, 'htop.desktop': <{'position': <12>}>, 'idea.desktop': <{'position': <13>}>, 'org.keepassxc.KeePassXC.desktop': <{'position': <14>}>, 'LibreOffice': <{'position': <15>}>, 'com.belmoussaoui.Obfuscate.desktop': <{'position': <16>}>, 'com.obsproject.Studio.desktop': <{'position': <17>}>, 'com.parsecgaming.parsec.desktop': <{'position': <18>}>, 'io.github.quodlibet.QuodLibet.desktop': <{'position': <19>}>, 'org.remmina.Remmina.desktop': <{'position': <20>}>, 'gnome-control-center.desktop': <{'position': <21>}>, 'org.gnome.Software.desktop': <{'position': <22>}>, 'org.gnome.SoundRecorder.desktop': <{'position': <23>}>}, {'org.gnome.TextEditor.Devel.desktop': <{'position': <0>}>, 'torbrowser.desktop': <{'position': <1>}>, 'Creativity': <{'position': <2>}>, 'Utilities': <{'position': <3>}>, 'virt-manager.desktop': <{'position': <4>}>, 'visual-studio-code.desktop': <{'position': <5>}>, 'org.gnome.Weather.desktop': <{'position': <6>}>, 'com.github.xournalpp.xournalpp.desktop': <{'position': <7>}>, 'com.yubico.yubioath.desktop': <{'position': <8>}>}]"
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
elif [ "${AR_OS}" == "darwin_macos" ]; then
    function defaults-write() {
        log silly "defaults write $*"
        defaults write "$@"
    }

    log info "Writing preferences"
    defaults-write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
    defaults-write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
    defaults-write com.apple.dock minimize-to-application -bool true
    defaults-write com.apple.Preview NSQuitAlwaysKeepsWindows -bool false
    defaults-write -g KeyRepeat -int 2
    defaults-write -g InitialKeyRepeat -int 15
    defaults-write -g ApplePressAndHoldEnabled -bool false
    defaults-write com.apple.dock size-immutable -bool true

    log info "Applying dock layout"
    defaults-write com.apple.Dock persistent-apps -array
    defaults-write com.apple.Dock persistent-others -array
    defaults-write com.apple.Dock recent-apps -array
    dockApps=("/System/Applications/Launchpad.app" "/Applications/Firefox.app" "/Applications/Discord.app" 
        "/Applications/iTerm.app" "/Applications/Visual Studio Code.app" "/Applications/Affinity Designer.app" 
        "/Applications/Pixelmator.app")
    
    # TODO: Figure out why vscode, affinity and photoshop dont get added to dock; something with spaces in their name
    for app in "${dockApps[@]}"; do
        if [ -e "${app}" ]; then
            log silly "Adding ${app} to dock"
            defaults-write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${app}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
        fi
    done
    killall Dock
fi

