# zsh
echo "source ~/.adryd/zsh/zshrc" > ~/.zshrc
cd ~/.adryd/zsh/oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh
cd ~/.adryd/zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting
if [[ $OS = "mac"]]; then; curl -L https://iterm2.com/shell_integration/zsh -o .iterm2_shell_integration.zsh; fi
