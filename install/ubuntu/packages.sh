a() {
  echo "> installing" "$@" "via brew"
  sudo apt install "$@" -y >/dev/null 2>/dev/null
}

s() {
  echo "> installing" "$@" "via cask"
  sudo snap install "$@" --classic >/dev/null 2>/dev/null
}

a ssh
a ubuntu-server

s code
s discord
s firefox