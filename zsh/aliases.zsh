alias ssh='TERM=xterm-256color ssh'
alias ls='ls -a --color'

alias rm="rm -rf -I"
alias rmf="rm -rf"

alias x+="chmod +x"

alias ..="cd .."
alias cd..="cd .."

alias dir="ls"
alias cls="clear"
alias nfetch="neofetch"
alias cask="brew cask"

alias ytdl="youtube-dl"
alias ytdl-mp3="youtube-dl --extract-audio --audio-format mp3"

tomp3() {
  ffmpeg -i $1 -vn -ar 44100 -ac 2 -ab 192k -f mp3 $2
}

