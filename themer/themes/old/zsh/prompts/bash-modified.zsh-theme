# Found on the ZshWiki
#  http://zshwiki.org/home/config/prompt
#

build_prompt() {
    echo %{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%%
}

PROMPT='%{%f%b%k%}$(build_prompt) '