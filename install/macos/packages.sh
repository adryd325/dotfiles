
b() {
  echo "> installing" "$@" "via brew"
  brew install "$@" >/dev/null
}

c() {
  echo "> installing" "$@" "via cask"
  brew cask install "$@" >/dev/null
}

n() {
  echo "> installing" "$@" "via npm"
  npm install -g "$@" >/dev/null
}

brew tap homebrew/cask-versions >/dev/null
brew tap homebrew/cask-drivers >/dev/null

b coreutils
b binutils
b ncurses
b diffutils
b ed 
b findutils
b gawk
b gnu-indent
b gnu-sed
b gnu-tar 
b gnu-which 
b gnutls
b grep 
b gzip
b screen
b watch
b wdiff 
b wget
b bash
b emacs
b gpatch
b less
b m4
b make
b nano
b file-formula
b git
b openssh
b perl
b rsync
b svn
b unzip
b vim 
b zsh
b tmux

b nodejs
b python
b python@2
b go

b tree
b figlet
b lolcat
b youtube-dl
b mitmproxy
b ffmpeg
b imagemagick
b speedtest-cli
b neofetch
b htop
b thefuck

c osxfuse
b ntfs-3g
b sshfs

c firefox-nightly 
c iterm2-nightly 
c visual-studio-code-insiders 
c discord-canary 
c 1password-beta

# c firefox 
# c iterm2 
# c visual-studio-code
# c discord
# c 1password

c apptrap 
c lulu 
c blockblock 
c knockknock 
c suspicious-package 
c uxprotect 

c dozer 
c nightowl 
c keka 
c macs-fan-control
c smcfancontrol
c soundflower
c dropbox

c qbittorrent
c postman
c daisydisk
c fedora-media-writer
c telegram
c clover-configurator
c steam
c virtualbox
c obs
c fl-studio
c tor-browser
c minecraft
c adobe-creative-cloud
c discord-ptb
c eloston-chromium
c audacity

n http-server
n asar
n firebase-tools