escapeInsert() {
  command=$1
  data=$2
  if [[ $ISTMUX ]]; then
    echo -e -n "\033Ptmux;\033\033\033]${command};${data}\007\033\\"
  else
    echo -e -n "\033]${command};${data}\a"
  fi
}

alias panic="dtrace -w -n \"BEGIN{ panic();}\""


loadfucks() {
  echo "Loading modules..."
  source $ADRYDDOTFILES/fuckery/phant.zsh
  source $ADRYDDOTFILES/fuckery/traa.zsh
  source $ADRYDDOTFILES/fuckery/tidy.zsh
  source $ADRYDDOTFILES/fuckery/chromium.zsh
  source $ADRYDDOTFILES/fuckery/colstress.zsh
  source $ADRYDDOTFILES/themer/zshrc.zsh # New theming module
  alias dos="source $ADRYDDOTFILES/fuckery/dos/msdos.zsh"
  echo "done."
}
