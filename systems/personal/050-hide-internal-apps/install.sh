#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="hide-internal-apps"

# if on linux
appDirs=("/usr/share/applications" "$HOME/.local/share/applications")
apps=(
    "nm-connection-editor.desktop"
    "qv4l2.desktop"
    "qvidcap.desktop"
    "ca.desrt.dconf-editor.desktop"
    "bssh.desktop"
    "bvnc.desktop"
    "remote-viewer.desktop"
    "avahi-discover.desktop"
    "electron.desktop"
    "electron11.desktop"
    "lstopo.desktop"
    "gtk3-demo.desktop"
    "gtk3-icon-browser.desktop"
    "gtk3-widget-factory.desktop"
    "cups.desktop"
    "torbrowser-settings.desktop"
    "org.gtk.Demo4.desktop"
    "org.gtk.IconBrowser4.desktop"
    "org.gtk.PrintEditor4.desktop"
    "org.gtk.WidgetFactory4.desktop"
    "jconsole-java-openjdk.desktop"
    "jshell-java-openjdk.desktop"
    "nvidia-settings.desktop"
    "cmake-gui.desktop"
    "xdvi.desktop"
    "hplip.desktop"
    "hp-uiscan.desktop"
    "designer.desktop"
    "assistant.desktop"
    "linguist.desktop"
    "qdbusviewer.desktop"
    "wine/Programs/Image-Line/More....desktop"
    "wine/Programs/ASIO4ALL v2/Uninstall.desktop"
    "wine/Programs/ASIO4ALL v2/ASIO4ALL Web Site.desktop"
    "wine/Programs/ASIO4ALL v2/ASIO4ALL v2 Instruction Manual.desktop"
)

if [ "$AR_OS" == "linux_archlinux" ]; then
    log info "Hiding internal apps"
    for appDir in "${appDirs[@]}"; do
        for app in "${apps[@]}"; do
            if [ -e "$appDir/$app" ] && ! grep -l "NoDisplay=true" "$appDir/$app" > /dev/null; then
                log silly "Hiding $app from apps menu"
                echo "NoDisplay=true" | sudo tee -a "$appDir/$app" > /dev/null
            fi
        done
    done
fi