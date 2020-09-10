function title() {
    echo -e " \x1b[30;44m            _                _ \x1b[0m"
    echo -e " \x1b[30;44m   __ _  __| |_ __ _   _  __| |\x1b[0m"
    echo -e " \x1b[30;44m  / _\` |/ _\` | '__| | | |/ _\` |\x1b[0m"
    echo -e " \x1b[30;44m | (_| | (_| | |  | |_| | (_| |\x1b[0m"
    echo -e " \x1b[30;44m(_)__,_|\__,_|_|   \__, |\__,_|\x1b[0m"
    echo -e " \x1b[30;44m        version $AR_VERSION|___/       \x1b[0m"
}

function subtitle() {
    echo -e " \x1b[30;44m \x1b[0m $1"
    echo -e " \x1b[30;44m \x1b[0m version $2"
}