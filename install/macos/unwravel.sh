# Function by Slice (https://github.com/slice/dotfiles/blob/floof/defaults.sh)
w() {
  echo "> defaults write" "$@"
  defaults write "$@"
}

# dock
w com.apple.dock minimize-to-application -bool true
w com.apple.dock magnification -bool false
w com.apple.dock orientation -string 'left'
w com.apple.dock enable-spring-load-actions-on-all-items true
w com.apple.dock autohide -bool true
w com.apple.dock autohide-time-modifier -float 0.12

# locale
w -g AppleLanguages -array "en" "fr"
w -g AppleLocale -string "en_US@currency=USD"
w -g AppleMeasurementUnits -string "Meters"
w -g AppleMetricUnits -bool true

# keyboard
w -g KeyRepeat -int 1
w -g InitialKeyRepeat -int 20
w -g ApplePressAndHoldEnabled -bool true

# spaces 
w com.apple.dock mru-spaces -bool false
w com.apple.dock dashboard-in-overlay -bool true 
w com.apple.dock expose-group-by-app -bool true
w com.apple.dashboard mcx-disabled -bool true

# finder
w com.apple.finder FXPreferredViewStyle -string 'clmv'
w com.apple.finder FXPreferredSearchViewStyle -string 'Nlsv'
w com.apple.finder FXEnableExtensionChangeWarning -bool false

# misc
w com.assple.SoftwareUpdate ScheduleFrequency -int 1
w NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
w com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
w com.apple.loginwindow TALLogoutSavesState -bool false
w com.apple.PhotoBooth EnableDebugMenu -bool true
w NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# zsh
echo "source ~/.adryd/zsh/zshrc" > ~/.zshrc
cd ~/.adryd/zsh/oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh
cd ~/.adryd/zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting

cp -rf ~/.adryd/vscode ~/.vscode
ln -s ~/.vscode ~/.vscode-insiders
mkdir ~/Library/Application\ Support/Code/
mkdir ~/Library/Application\ Support/Code/User
echo "{}" > ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/Library/Application\ Support/Code/User/settings.json ~/.adryd/themer/vscode.json
ln -s mkdir ~/Library/Application\ Support/Code ~/Library/Application\ Support/Code\ -\ insiders

mkdir ~/Library/Application\ Support/iTerm2/
mkdir ~/Library/Application\ Support/iTerm2/DynamicProfiles
echo "" > ~/Library/Application\ Support/iTerm2/DynamicProfiles/adryd
ln -s ~/Library/Application\ Support/iTerm2/DynamicProfiles/adryd ~/.adryd/themer/iterm.json
cp ~/.adryd/setup/files/com.googlecode.iterm2.plist ~/Library/Prefrences/com.googlecode.iterm2.plist

# brew cask list | grep firefox-nightly
# sudo ln -s ~/.adryd/firefox/mozilla.cfg /Applications/Firefox\ Nightly.app/Contents/Resources/mozilla.cfg
# sudo ln -s ~/.adryd/firefox/local-settings.js /Applications/Firefox\ Nightly.app/Contents/Resources/defaults/pref/local-settings.js

# brew cask list | grep "firefox[ \n]" # I know it's hacky, but try grep "firefox(?!-nightly)"
# sudo ln -s ~/.adryd/firefox/local-settings.js /Applications/Firefox.app/Contents/Resources/defaults/pref/local-settings.js
# sudo ln -s ~/.adryd/firefox/mozilla.cfg /Applications/Firefox.app/Contents/Resources/mozilla.cfg

cp -rf ~/.adryd/install/global/files/terminfo ~/.terminfo  
sudo cp -rf ~/.adryd/install/macos/files/shells /etc/shells
chsh -s /usr/local/bin/zsh
sudo cp -rf ~/.adryd/install/macos/files/sudo /etc/pam.d/sudo

sudo cp ~/.adryd/install/macos/files/startup.app /Applications/startup.app