# Found on the ZshWiki
#  http://zshwiki.org/home/config/prompt
#


build_prompt() {
    echo %{$fg[green]%}%n@%m%{$reset_color%}: %{$fg[blue]%}%~ %{$reset_color%}$
}

PROMPT='%{%f%b%k%}$(build_prompt) '