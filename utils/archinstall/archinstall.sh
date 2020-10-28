source $AR_DOTFILES_DIR/lib/logger.sh

log 0 'archiso' 'enabling ntp...'
timedatectl set-ntp true

log 6 'archiso' 'gathering setup information'
log 7 'archiso' 'username: '
log 7 'archiso' 'password: '
log 7 'archiso' 'password (confirm): '
log 7 'archiso' 'hostname: '
log 7 'archiso' 'timezone: '
log 7 'archiso' 'root logon enabled [y/N]: '
log 7 'archiso' 'encrypt disk? [y/N]: '
log 7 'archiso' 'install DE? [y/N]: '

log 6 'archiso' 'please partition and mount drives to /mnt'
# if encrypt
log 6 'archiso' 'the cryptlvm name should be the same as the hostname'
log 6 'archiso' "run 'exit' to continue"
zsh

if [[ $arEncrypt = true ]]; then
    log 7 'archiso' 'luks partition (block device): '
fi

arPackages='base base-devel linux linux-firmware'
[[ $arUsername = 'adryd' && $arHostname = 'popsicle' ]] && arPackages="$arPackages intel-ucode nvidia"
[[ $arEncrypt = true ]] && arPackages="$arPackages lvm2"
# essentials
arPackages="$arPackages sudo nano git" # nano is not needed for automated install but it's useful if something fucks up
# boot
arPackages="$arPackages grub os-prober efibootmgr"

pacstrap /mnt $arPackages