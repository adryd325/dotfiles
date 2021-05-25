function ar_os() {
    export AR_KERNEL=`uname -s | tr '[:upper:]' '[:lower:]'`
    if [ "$AR_KERNEL" == "linux" ]; then
        # This is what neofetch does, so I feel safe doing the same
        [ -e /etc/os-release ] && source /etc/os-release
        export AR_DISTRO=`echo $ID | sed "s/ //g" | tr '[:upper:]' '[:lower:]'`
        export AR_OS="${AR_KERNEL}_$AR_DISTRO"
    fi
    if [ "$AR_KERNEL" == "darwin" ]; then
        export AR_DISTRO='macos'
        export AR_OS="${AR_KERNEL}_$AR_DISTRO"
    fi
}
ar_os