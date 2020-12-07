source $AR_DIR/lib/logger.sh

function ucodepkg() {
    arArchinstallCputype=$(cat /proc/cpuinfo | grep vendor_id | sed "s/vendor_id\t: //g" | head -1)
    [[ $arArchinstallCputype = 'GenuineIntel' ]] && printf 'intel-ucode'
    [[ $arArchinstallCputype = 'AuthenticAmd' ]] && printf 'amd-ucode'
}

# mostsecure.pw
# THIS SHOULD NEVER BE USED IN PRODUCTION
arArchinstallRootPassword='H4!b5at+kWls-8yh4Guq'

log 6 'archinstall' 'Gathering setup information'

[[ $AR_TESTING ]] && log 4 'archinstall' 'Installation in testing mode, using VM values'

# get username
[[ $AR_TESTING ]] && arArchinstallUsername=adryd
while [[ $arArchinstallUsername = '' || $arArchinstallUsername = root ]]; do
    [[ $arArchinstallUsername == 'root' ]] && log 5 'archinstall' "Invalid Username"
    log 7 'archinstall' 'Username: '
    read arArchinstallUsername
done

# get password
[[ $AR_TESTING ]] && arArchinstallPassword=demo && arArchinstallPasswordConfirm=demo
while [[ $arArchinstallPassword = '' || $arArchinstallPassword != $arArchinstallPasswordConfirm ]]; do
    [[ $arArchinstallPassword != $arArchinstallPasswordConfirm ]] && log 5 'archinstall' 'Passwords do not match'
    log 7 'archinstall' 'Password: '
    read -s arArchinstallPassword
    echo
    log 7 'archinstall' 'Password (confirm): '
    read -s arArchinstallPasswordConfirm
    echo
done
arArchinstallPasswordConfirm='' # null it, just one less thing to worry about later

# get hostname
[[ $AR_TESTING ]] && arArchinstallHostname=demo
if [[ $arArchinstallHostname = '' ]]; then
    log 7 'archinstall' 'Hostname [localhost]: '
    read arArchinstallHostname
    [[ $arArchinstallHostname = '' ]] && arArchinstallHostname='localhost'
fi

# get timezone
arArchinstallTimezone='unset' # to prevent the directory from being detected
[[ $AR_TESTING ]] && arArchinstallTimezone='America/Toronto'
while [[ ! -e /usr/share/zoneinfo/$arArchinstallTimezone ]]; do
    [[ ! -e /usr/share/zoneinfo/$arArchinstallTimezone ]] && [[ $arArchinstallTimezone != 'unset' ]] && log 5 'archinstall' 'Invalid timezone'
    [[ $arArchinstallTimezone = 'l' ]] && find /usr/share/zoneinfo | sed 's/\/usr\/share\/zoneinfo\///g' | less
    log 7 'archinstall' 'Timezone (l for a list): '
    read arArchinstallTimezone
    [[ $arArchinstallTimezone = '' ]] && arArchinstallTimezone='unset'
done

# ask if root password should exist
[[ $AR_TESTING ]] && arArchinstallRootLogon=true
while [[ $arArchinstallRootLogon = '' ]]; do
    log 7 'archinstall' 'Root logon enabled [y/N]: '
    read arArchinstallRootLogon
    arArchinstallRootLogon=false
    [[ "${arArchinstallRootLogon,,}" = 'y' ]] && arArchinstallRootLogon=true
done

# ask to install DE
# install gnome, networkmanager and some extras
[[ $AR_TESTING ]] && arArchinstallDesktop=true
while [[ $arArchinstallDesktop = '' ]]; do
    log 7 'archinstall' 'Install DE? [y/N]: '
    read arArchinstallDesktop
    arArchinstallDesktop=false
    [[ "${arArchinstallDesktop,,}" = 'y' ]] && arArchinstallDesktop=true
done

# get installation target
[[ $AR_TESTING ]] && arArchinstallBlockdevice='/dev/vda'
while [[ ! -e $arArchinstallBlockdevice ]]; do
    [[ ! -e $arArchinstallBlockdevice ]] && [[ $arArchinstallBlockdevice != '' ]] && log 5 'archinstall' 'Invalid block device'
    [[ $arArchinstallBlockdevice = 'l' ]] && lsblk | less
    log 7 'archinstall' 'Target disk (l for a list): '
    read arArchinstallBlockdevice
done

log 4 'archinstall' 'Root logon is enabled with default password.'

[[ $AR_TESTING ]] && arArchinstallConfirm="CoNtInUe"
log 6 'archinstall' "You should probably securely wipe your drive prior to, unless you already use an encrypted drive"
log 6 'archinstall' "$arArchinstallBlockdevice will be nuked. (insecurely)"
log 6 'archinstall' "\x1b[41m!! ARE YOU SURE YOU WANT TO CONTINUE !!\x1b[0m type \"CoNtInUe\" to proceed"
while [[ $arArchinstallConfirm != 'CoNtInUe' ]]; do
    log 7 'archinstall' 'Enter confirmation phrase: '
    read arArchinstallConfirm
done

# in case Ctrl+C somehow fucks up in the read or smth
if [[ $arArchinstallConfirm = 'CoNtInUe' ]]; then

    # partition format taken from here cause I like it
    # https://wiki.archlinux.org/index.php/User:Altercation/Bullet_Proof_Arch_Install#Partition_&_Format_Drive
    
    # cursed
    arArchinstallPartitionRam=$(cat /proc/meminfo | grep "MemTotal" | sed "s/MemTotal:[ ]*//g" | sed "s/ kB/KB/g")

    log 3 'archinstall partitioning' "Nuking partitions on $arArchInstallBlockdevice."
    wipefs --all $arArchinstallBlockdevice &> $AR_TTY
    # for good measure
    log 0 'archinstall partitioning' "Nuking partitions with a different tool for good measure."
    sgdisk --zap-all $arArchinstallBlockdevice &> $AR_TTY
    log 3 'archinstall partitioning' "Creating partition table..."
    sgdisk --clear \
         --new=1:0:+1G                           --typecode=1:ef00 --change-name=1:EFI \
         --new=2:0:+$arArchinstallPartitionRam   --typecode=2:8200 --change-name=2:swap \
         --new=3:0:0                             --typecode=3:8300 --change-name=3:$arArchinstallHostname \
           $arArchinstallBlockdevice &> $AR_TTY
    log 3 'archinstall partitioning' "Creating partitions..."
    # give the kernel a sec to catch up
    sleep 3
    log 1 'archinstall partitioning' 'Making efi partition...'
    mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI &> $AR_TTY
    log 0 'archinstall partitioning' 'Making luks partition for btrfs...'
    echo "$arArchinstallPassword" | cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64 /dev/disk/by-partlabel/$arArchinstallHostname -q &> $AR_TTY
    echo "$arArchinstallPassword" | cryptsetup open /dev/disk/by-partlabel/$arArchinstallHostname system &> $AR_TTY
    log 0 'archinstall partitioning' 'Making dm-crypt partition for swap...'
    cryptsetup open --type plain --key-file /dev/urandom /dev/disk/by-partlabel/swap swap &> $AR_TTY
    log 1 'archinstall partitioning' 'Making swap...'
    mkswap -L swap /dev/mapper/swap &> $AR_TTY
    log 1 'archinstall partitioning' 'Enabling swap...'
    swapon -L swap &> $AR_TTY
    log 1 'archinstall partitioning' 'Making btrfs...'
    mkfs.btrfs --force --label $arArchinstallHostname /dev/mapper/$arArchinstallHostname &> $AR_TTY
    # not sure what this does, just following the instructions
    o=defaults,x-mount.mkdir
    o_btrfs=$o,compress=lzo,ssd,noatime
    log 0 'archinstall partitioning' 'Mounting btrfs...'
    mount -t btrfs LABEL=$arArchinstallHostname /mnt
    log 1 'archinstall partitioning' 'Creating btrfs subvolumes...'
    btrfs subvolume create /mnt/root
    btrfs subvolume create /mnt/home
    umount -R /mnt
    log 1 'archinstall partitioning' 'Mounting btrfs subvolumes...'
    mount -t btrfs -o subvol=root,$o_btrfs LABEL=$arArchinstallHostname /mnt
    mount -t btrfs -o subvol=home,$o_btrfs LABEL=$arArchinstallHostname /mnt/home
    # ABSOLUTE MINIMUM BASE PACKAGES
    pacstrap /mnt base base-devel linux linux-firmware $(ucodepkg) nano grub
    log 3 'archinstall' 'okay, you do the rest'
fi
