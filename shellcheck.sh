#!/usr/bin/env bash
# find . -name '**.sh' -exec ./shellcheck.sh {} \;
function check {
    (
        if ! git check-ignore "$1" &> /dev/null; then
            cd "$(dirname "$1")"
            shellcheck -x "$(basename "$1")"
        fi
    ) && return
    echo -e "\n\x1b[1;31m ** $1 **"
    read -r
    clear
}

check "$@"
