i() {
  echo "> installing" "$@" "via vscode"
  code --install-package "$@" >/dev/null 2>/dev/null
}

# themes
i dracula-theme.theme-dracula
i akamud.vscode-theme-onedark
i adamgirton.gloom
i benjaminblonde.monokai-alt
i arcticicestudio.nord-visual-studio-code
i whizkydee.material-palenight-theme
i thomaspink.theme-github
i miguelsolorio.min-theme
i jibjack.nineties
i be5invis.vscode-custom-css
i RobbOwen.synthwave-vscode

# language features
i mgmcdermott.vscode-language-babel
i levertion.mcjson
i eg2.vscode-npm-script

# misc features
i teelang.vsprettier
i dbaeumer.vscode-eslint
i coenraads.bracket-pair-colorizer
i waderyan.gitblame
i slevesque.vscode-hexdump

# ide features
i ms-vscode-remote.remote-ssh
i ms-vscode-remote.remote-ssh-edit
i ms-vscode-remote.remote-ssh-explorer
i ms-vsliveshare.vsliveshare
