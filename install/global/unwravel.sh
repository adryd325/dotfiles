# zsh
echo "source ~/.adryd/zsh/zshrc" > ~/.zshrc
cd ~/.adryd/zsh
git clone https://github.com/robbyrussell/oh-my-zsh
mkdir ~/.adryd/zsh/plugins
cd ~/.adryd/zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting
mkdir iterm 
curl -L https://iterm2.com/shell_integration/zsh -o ~/.adryd/zsh/plugins/.iterm2_shell_integration.zsh

# themer
cd ~/.adryd/themer
npm install

# vscode
cp -rf ~/.adryd/vscode/extensions/adryd- ~/.vscode
ln -s ~/.vscode ~/.vscode-insiders
mkdir ~/.config
if [[ $OS = "mac" ]]
then
  mkdir ~/Library/Application\ Support/Code/
  ln -s ~/Library/Application\ Support/Code/ ~/.config/Code
  ln -s ~/Library/Application\ Support/Code ~/Library/Application\ Support/Code\ -\ Insiders
fi
mkdir ~/.config/Code
ln -s ~/.config/Code\ -\ Insiders
mkdir ~/.config/Code/User/
echo "{}" > ~/.config/Code/User/settings.json
ln -s ~/.config/Code/User/settings.json ~/.adryd/themer/vscode.json

# terminfo
cp -rf ~/.adryd/install/global/files/terminfo ~/.terminfo  