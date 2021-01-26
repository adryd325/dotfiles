function ensure() {
    ensurePackages=$@
    ensurePackageQueue=()
    ensureCmd='sudo pacman'
    [[ -x "$(command -v yay)" ]] && ensureCmd='yay'

    for ensurePackage in "${ensurePackages[@]}"; do
        $ensureCmd -Qi $ensurePackage 2> /dev/null
        [[ $? -eq 1 ]] && ensurePackageQueue+="$ensurePackage"
    done

    if [[ ! $ensurePackageQueue == '' ]]; then
        log 3 "Ensuring dependencies; $ensurePackageQueue"
        $ensureCmd -Syq --noconfirm $ensurePackageQueue > /dev/null
    fi
}