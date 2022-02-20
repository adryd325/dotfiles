#!/usr/bin/env bash
function getKernel {
    printf %s "$(uname -s | tr '[:upper:]' '[:lower:]')"
}

function getDistro {
    if [[ "$(getKernel)" = "linux" ]] && [[ -f /etc/os-release ]]; then
        source /etc/os-release
        tr '[:upper:]' '[:lower:]' <<< "${ID/ /}" | sed 's/^arch$/archlinux/'
        return
    fi
    if [[ "$(getKernel)" = "darwin" ]]; then
        printf "macos"
        return
    fi
    printf "unknown"
}

function ensureInstalled {
    case "$(getDistro)" in
        "archlinux")
            packageQueue=()
            for package in "$@"; do
                if ! pacman -Q "${package}" &> /dev/null; then
                    packageQueue+=("${package}")
                fi
            done
            if (( ${#packageQueue[@]} != 0 )); then
                sudo pacman -S "${packageQueue[*]}" --noconfirm # --asdeps
            fi
            ;;
        *)
            echo "ensureInstalled is not supported on this os"
            ;;
    esac
}

function ensureDependencies {
    case "$(getDistro)" in
        "archlinux")
            packageQueue=()
            for package in "$@"; do
                if ! pacman -Q "${package}" &> /dev/null; then
                    packageQueue+=("${package}")
                fi
            done
            if (( ${#packageQueue[@]} != 0 )); then
                sudo pacman -S "${packageQueue[*]}" --noconfirm --asdeps
            fi
            ;;
        *)
            echo "ensureDependencies is not supported on this os"
            ;;
    esac
}
