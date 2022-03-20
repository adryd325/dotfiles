#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
AR_MODULE="preferences"

function defaults-write {
    log silly "defaults write $*"
    defaults write "$@"
}

log info "Writing preferences"
defaults-write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults-write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
defaults-write com.apple.dock minimize-to-application -bool true
defaults-write com.apple.Preview NSQuitAlwaysKeepsWindows -bool false
defaults-write -g KeyRepeat -int 2
defaults-write -g InitialKeyRepeat -int 25
defaults-write -g ApplePressAndHoldEnabled -bool false
defaults-write -g com.apple.swipescrolldirection -bool FALSE
defaults-write com.apple.dock size-immutable -bool true

log info "Applying dock layout"
defaults-write com.apple.Dock persistent-apps -array
defaults-write com.apple.Dock persistent-others -array
defaults-write com.apple.Dock recent-apps -array
dockApps=("/System/Applications/Launchpad.app" "/Applications/Safari.app" "/Applications/Discord Canary.app"
    "/Applications/iTerm.app" "/Applications/Visual Studio Code.app" "/Applications/Affinity Designer Beta.app")

for app in "${dockApps[@]}"; do
    if [ -e "${app}" ]; then
        log silly "Adding ${app} to dock"
        defaults-write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${app}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    fi
done
killall Dock
