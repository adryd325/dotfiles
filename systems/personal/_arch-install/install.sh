#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "$AR_DIR" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "$AR_DIR"/constants.sh
AR_MODULE="archinstall"

log tell "Re-bootstrap preserves user data but deletes root and boot partitions."
log ask "Is this a re-bootstrap of a current install? [y/N] "
read -r rebootstrapAsk
if [[ "${rebootstrapAsk^^}" = "y" ]]; then
    rebootstrap=1
fi

# Username
while [[ "$username" = "" ]] || [[ "$username" = "root" ]]; do
    log ask "Username: "
    read -r username
done
export username

# Password
while [[ "$password" = "" ]] || [[ "$password" != "$passwordConfirm" ]]; do
    [[ "$password" != "$passwordConfirm" ]] \
        && log tell "Passwords do not match"
    log ask "Login Password: "
    read -rs password
    echo
    log ask "Login Password (confirm): "
    read -rs passwordConfirm
    echo
done
export password
unset passwordConfirm

# Disk Password
while [[ "$diskPassword" = "" ]] || [[ "$diskPassword" != "$diskPasswordConfirm" ]]; do
    [[ "$diskPassword" != "$diskPasswordConfirm" ]] \
        && log tell "Passwords do not match"
    log ask "Disk Password: "
    read -rs diskPassword
    echo
    log ask "Disk Password (confirm): "
    read -rs diskPasswordConfirm
    echo
done
export diskPassword
unset diskPasswordConfirm 


# Hostname
if [[ "$host" = "" ]]; then
    if [[ -z "$rebootstrap" ]]; then
        failHostname="adryd-machine-$RANDOM"
        log ask "Hostname [$failHostname]: "
        read -r host
        [[ "$host" = "" ]] && host="$failHostname"
    else
        while [[ "$host" = "" ]]; do 
            log ask "Current system's hostname: "
            read -r host
        done
    fi
fi
export host
unset failHostname

# Installation Target
if [[ -z "$rebootstrap" ]]; then
    while [ ! -e "$installTargetDev" ]; do
        [ ! -e "$installTargetDev" ] && [ "$installTargetDev" != "" ] && log tell "Invalid block device"
        [ "$installTargetDev" = "l" ] && lsblk | less
        log ask "Target disk (l for a list): "
        read -r installTargetDev
    done
    export installTargetDev

    installTargetUUID="$(lsblk -l "$installTargetDev" -o PATH,UUID | grep "$installTargetDev" | grep -oP "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}")"
    export installTargetUUID
    log tell "Install Target UUID: $installTargetUUID"
fi

[[ "$timezone" = "" ]] && timezone="America/Toronto"
[[ "$language" = "" ]] && language="en_CA.UTF-8"
[[ "$keymap" = "" ]] && keymap="us"
[[ "$basePackages" = "" ]] && basePackages=("linux" "linux-firmware" "linux-headers" "base" "base-devel" "man-db" "man-pages" "btrfs-progs"
    "networkmanager" "neovim" "git" "bash" "openssh")

log tell "Timezone: $timezone"
log tell "Language: $language"
log tell "Keymap: $keymap"

export timezone
export language
export keymap
export basePackages

confirmationStr="I understand."
log tell "WARNING: This script may behave unpredictabily. Please read the following"
[[ -z "$rebootstrap" ]] && log tell "\"$installTargetDev\", \"/dev/disk/by-partlabel/EFI\" and \"/dev/disk/by-partlabel/$host\" will be formatted."
[[ -n "$rebootstrap" ]] && log tell "\"/dev/disk/by-partlabel/$host\" will mounted. btrfs partition \"root\" and \"/dev/disk/by-partlabel/EFI\" will be cleared."
while [[ "$confirmation" != "$confirmationStr" ]]; do
    log ask "Type \"$confirmationStr\" to continue or \"exit\" to exit"
    read -r confirmation
    [[ "$confirmation" = "exit" ]] && exit 0
done
unset confirmation

if [[ -z "$rebootstrap" ]]; then
    log silly "Calling partitioning script"
    "$AR_DIR"/systems/personal/_arch-install/partition.sh
else
    log info "Mounting current install"
    cryptsetup open /dev/disk/by-partlabel/"$host" "$host"
    mountOptions=defaults,x-mount.mkdir
    btrfsOptions=$mountOptions,compress=zstd,ssd,noatime,discard
    mount -t btrfs -o "subvol=root,$btrfsOptions" LABEL="$host" /mnt
    mount -o "$mountOptions" /dev/disk/by-partlabel/EFI /mnt/boot
    log info "Creating package list backup"
    arch-chroot /mnt pacman -Qetq > /tmp/old-package-list.txt
    log info "Creating fstab backup"
    cp /mnt/etc/fstab /tmp/old-fstab
    log info "Clearing root"
    rm -rf /mnt/"${*:?}"
fi

function ucodepkg() {
    cpuType=$(grep vendor_id /proc/cpuinfo | sed "s/vendor_id\t: //g" | head -1)
    [[ "$cpuType" = "GenuineIntel" ]] && printf "intel-ucode"
    [[ "$cpuType" = "AuthenticAmd" ]] && printf "amd-ucode"
}

log silly "Detecting CPU for microcode package"
basePackages+=("$(ucodepkg)")

log info "Run relfector to speed up installation"
"$AR_DIR"/systems/personal/_install/03-reflector.sh

log info "Enable parallel downloads in pacman"
sed -i "s/^#ParallelDownloads = 5\$/ParallelDownloads = 12/" /etc/pacman.conf

log info "Installing base system"
pacstrap /mnt "${basePackages[@]}"

if [[ -n "$rebootstrap" ]]; then
    log info "Restoring fstab"
    cp /tmp/old-fstab /mnt/etc/fstab
else
    log info "Writing fstab"
    genfstab /mnt -U >> /mnt/etc/fstab
fi

log info "Copying over .adryd"
cp -r "$AR_DIR" "/mnt$AR_DIR"

log info "Copying over mirrorlist"
mv /mnt/etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist.arbak
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

rootUUID="$(lsblk -o UUID,PARTLABEL | grep "$host" | grep -oP "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}")"
export rootUUID

ucode="$(ucodepkg)"
export ucode

arch-chroot /mnt bash "$AR_DIR"/systems/personal/_arch-install/configure.sh

unset password
unset diskPassword

# Remove coppied dotfiles
log silly "Remove coppied dotfiles"
rm -rf /mnt/"${AR_DIR:?}"
log silly "Placing install script in home folder"
cp "$AR_DIR"/download.sh /mnt/home/"$username"/install.sh
log silly "Placing old package list in home folder"
cp /tmp/old-package-list.txt /mnt/home/"$username"/old-package-list.txt
