# Installer that may be curl'ed and run quickly
# curl -fsSL https://adryd.co/install | sh
cd ~
curl -fsSL https://codeload.github.com/adryd325/dotfiles/zip/master > adryd.zip # raw.githubusercontent.com is blocked
unzip adryd.zip
mv -f ./dotfiles-master ./.adryd-test
rm -rf ./adryd.zip
~/.adryd-test/install/install.sh
