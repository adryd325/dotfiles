source /lib/logger.sh

read -p 'Hostname: ' AR_HOSTNAME
read -p 'Username: ' AR_USERNAME
read -ps 'Password: ' AR_PASSWORD
read -p 'Timezone: ' AR_TIMEZONE
read -p 'Install DE: [y/N]: ' AR_INSTALL_DE
[[ $AR_HOSTNAME = 'popsicle' ]] && AR_IS_POPSICLE=true && AR_IS_ADRYD=true
[[ $AR_HOSTNAME = 'leaf' ]] && AR_IS_LEAF=true && AR_IS_ADRYD=true

tell 'archiso' 'Please partition and mount the target disk at /mnt'
tell 'archiso' 'type exit when completed'

PKGLIST='base base-devel linux linux-firmware'
[[ $AR_IS_POPSICLE ]] PKGLIST="$PKGLIST intel-ucode nvidia lvm2"
PKGLIST="$PKGLIST sudo nano git"
PKGLIST="$PKGLIST grub os-prober efibootmgr"
pacstrap /mnt $PKGLIST
genfstab -U /mnt >> /mnt/etc/fstab
cat /adryd/postpacstrap.sh | arch-chroot /mnt


# this is cursed but oh well, sucks to suck
echo "$(env)\n$(cat $AR_DOTFILES_LOCATION/lib/logger)\n$(cat $AR_DOTFILES_LOCATION/opt/archinstall/chroot.sh)" | arch-chroot /mnt