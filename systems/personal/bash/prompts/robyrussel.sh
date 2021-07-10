prompt_exitcode() {
    [[ $exitCode -eq 0 ]] && prompt+="\[\e[1;32m\]" && return
    prompt+="\[\e[1;31m\]"
}

prompt_git() {
    branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [[ -n "$branch" ]]; then
        status="$(git status 2>&1 | tee)"
        bits=""
        echo -n "$status" 2> /dev/null | grep "renamed:" &> /dev/null && bits+=">"
        echo -n "$status" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null && bits+="*"
        echo -n "$status" 2> /dev/null | grep "new file:" &> /dev/null && bits+="+"
        echo -n "$status" 2> /dev/null | grep "Untracked files" &> /dev/null && bits+="?"
        echo -n "$status" 2> /dev/null | grep "deleted:" &> /dev/null && bits+="x"
        echo -n "$status" 2> /dev/null | grep "modified:" &> /dev/null && bits+="!"
        if [[ -n "$bits" ]]; then
            prompt+=" \[\e[32m\]git:(\[\e[31m\]$branch\[\e[32m\])\[\e[33m\]$bits\[\e[0m\]"
        else
            prompt+=" \[\e[32m\]git:(\[\e[31m\]$branch\[\e[32m\])\[\e[0m\]"
        fi
    fi
}

build_prompt() {
    exitCode=$?
    prompt_exitcode
    prompt+="->\[\e[36m\] \w"
    prompt_git
    prompt+="\[\e[0m\] "
    PS1="$prompt"
    prompt=""
}

PROMPT_COMMAND=build_prompt
