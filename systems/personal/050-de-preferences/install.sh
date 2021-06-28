#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="de-preferences"

if [ "$AR_OS" == "linux_arch" ]; then
    log info "Writing misc dconf preferences"
    
    # Terminal
    gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
    gsettings set org.gnome.Terminal.Legacy.Settings menu-accelerator-enabled false

    gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
    gsettings set org.gnome.desktop.privacy remove-old-temp-files true
    gsettings set org.gnome.desktop.privacy remove-old-trash-files true

    # Shell
    gsettings set org.gnome.mutter center-new-windows true
    gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox-developer-edition.desktop', 'org.gnome.Terminal.desktop']"
    gsettings set org.gnome.shell app-picker-layout "[{'audacity.desktop': <{'position': <0>}>, 'code-oss.desktop': <{'position': <1>}>, 'ff58ebb6-357c-475a-bbc7-ef300f8ba4b4': <{'position': <2>}>, 'org.gnome.Cheese.desktop': <{'position': <3>}>, 'deluge.desktop': <{'position': <4>}>, 'wine-Programs-Image-Line-FL Studio 20.desktop': <{'position': <5>}>, '2ee2dc11-e8a8-43bd-8fe7-8c1d5ffe94a4': <{'position': <6>}>, 'gimp.desktop': <{'position': <7>}>, 'htop.desktop': <{'position': <8>}>, 'org.inkscape.Inkscape.desktop': <{'position': <9>}>, 'org.keepassxc.KeePassXC.desktop': <{'position': <10>}>, 'b7a26776-7876-421f-a5f0-8b95d40bc91e': <{'position': <11>}>, 'nvim.desktop': <{'position': <12>}>, 'com.obsproject.Studio.desktop': <{'position': <13>}>, 'org.remmina.Remmina.desktop': <{'position': <14>}>, 'gnome-control-center.desktop': <{'position': <15>}>, 'org.gnome.Software.desktop': <{'position': <16>}>, 'org.gnome.gedit.desktop': <{'position': <17>}>, 'torbrowser.desktop': <{'position': <18>}>, 'Utilities': <{'position': <19>}>, 'vlc.desktop': <{'position': <20>}>, 'org.gnome.Weather.desktop': <{'position': <21>}>, 'com.github.xournalpp.xournalpp.desktop': <{'position': <22>}>, 'visual-studio-code.desktop': <{'position': <23>}>}]"
    gsettings set org.gnome.shell.weather locations "[<(uint32 2, <('Toronto', 'CYTZ', true, [(0.76154532446909495, -1.3857914260834978)], [(0.76212711252195475, -1.3860823201099277)])>)>]"
    gsettings set org.gnome.desktop.app-folders folder-children "['Utilities', 'b7a26776-7876-421f-a5f0-8b95d40bc91e', '2ee2dc11-e8a8-43bd-8fe7-8c1d5ffe94a4', 'ff58ebb6-357c-475a-bbc7-ef300f8ba4b4']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/2ee2dc11-e8a8-43bd-8fe7-8c1d5ffe94a4/ apps "['steam.desktop', 'multimc.desktop', 'powder-toy.desktop', 'supertuxkart.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/2ee2dc11-e8a8-43bd-8fe7-8c1d5ffe94a4/ name 'Games'
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/b7a26776-7876-421f-a5f0-8b95d40bc91e/ apps "['libreoffice-startcenter.desktop', 'libreoffice-calc.desktop', 'libreoffice-impress.desktop', 'libreoffice-writer.desktop', 'libreoffice-base.desktop', 'libreoffice-draw.desktop', 'libreoffice-math.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/b7a26776-7876-421f-a5f0-8b95d40bc91e/ name 'LibreOffice'
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/ff58ebb6-357c-475a-bbc7-ef300f8ba4b4/ apps "['discord.desktop', 'pidgin.desktop', 'telegramdesktop.desktop', 'mumble.desktop', 'quassel.desktop', 'discord-ptb.desktop', 'discord-canary.desktop', 'discord-development.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/ff58ebb6-357c-475a-bbc7-ef300f8ba4b4/ name 'Chats'
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ apps "['org.gnome.DiskUtility.desktop', 'org.gnome.eog.desktop', 'org.gnome.Evince.desktop', 'org.gnome.FileRoller.desktop', 'org.gnome.Extensions.desktop', 'org.gnome.Screenshot.desktop', 'org.gnome.tweaks.desktop', 'org.gnome.Totem.desktop', 'org.gnome.Calculator.desktop', 'pavucontrol.desktop', 'org.gnome.baobab.desktop', 'com.uploadedlobster.peek.desktop', 'gnome-system-monitor.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ name 'Utilities'
elif [ "$AR_OS" == "darwin_macos" ]; then
    function defaults-write() {
        log silly "defaults write $@"
        defaults write $@
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
        "/Applications/Adobe Photoshop 2021/Adobe Photoshop 2021.app" "/Applications/Pixelmator.app")
    
    # TODO: Figure out why vscode, affinity and photoshop dont get added to dock; something with spaces in their name
    for app in "${dockApps[@]}"; do
        if [ -e "$app" ]; then
            log silly "Adding $app to dock"
            defaults-write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
        fi
    done
    killall Dock
fi

