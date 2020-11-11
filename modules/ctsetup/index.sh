#!/bin/bash
# Setup Pacman
source $AR_DIR/lib/logger.sh
log 3 'ctsetup' 'Setting up pacman-key.'
pacman-key --init &> $AR_TTY
log 3 'ctsetup' 'Populating pacman-key.'
pacman-key --populate archlinux &> $AR_TTY
# back up default mirror list
log 1 'ctsetup' 'Installing mirrorlist.'
[[ ! -e /etc/pacman.d/mirrorlist.orig ]] && cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
# no symlinking (security risk)
mv -f $AR_DIR/modules/pacman/mirrorlist /etc/pacman.d/mirrorlist
chmod 644 /etc/pacman.d/mirrorlist # just to be sure
log 3 'ctsetup' 'Updating system.'
pacman -Syyuq --noconfirm
log 3 'ctsetup' 'Installing packages.'
pacman -Sq sudo nano git openssh curl fail2ban

# create 'adryd' admin user
log 3 'ctsetup' 'Creating admin user.'
useradd -mG wheel adryd 

# allow wheel to use sudo
log 0 'ctsetup' 'Allowing wheel sudo access.'
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# fix ssh security
# https://www.cyberciti.biz/tips/linux-unix-bsd-openssh-server-best-practices.html
# bind only one address
# cts on lemon should only bind 10.100 to 10.199, by the time I need to expand, I think this script will have been depracated
# this is *probably* cursed
log 0 'ctsetup' 'Setting SSH restrictions.'
arCtArchInstallIpAddress="$(ip address | grep -oh 'inet 10.0.0.1[0-9][0-9]/24' | sed 's/inet //' | sed 's./24..')"
sed -i "s/#ListenAddress 0.0.0.0/ListenAddress $arCtArchInstallIpAddress/" /etc/ssh/sshd_config
# disable password auth
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication no/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
# ChallengeResponseAuthentication no (already set to no on Arch)
# only allow the admin user to access the server over ssh
echo 'AllowUsers adryd' >> /etc/ssh/sshd_config
# only allow publickey authorization
echo 'AuthenticationMethods publickey' >> /etc/ssh/sshd_config
log 3 'ctsetup' 'Enabling SSH.'
systemctl enable --now sshd

