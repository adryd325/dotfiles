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
log 3 'ctsetup' 'Updating system and installing packages.'
pacman -Syyuq sudo nano git openssh curl fail2ban base-devel --noconfirm

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

source $AR_DIR/lib/logger.sh
# move ssh authorised keys from root to admin user
log 3 'ctsetup' 'Putting SSH key in place.'
mkdir -p /home/adryd/.ssh
mv /root/.ssh/authorized_keys /home/adryd/.ssh/authorized_keys
chown adryd:adryd /home/adryd/.ssh/authorized_keys

log 3 'ctsetup' 'Locking root user.'
chage -E 0 root

log 3 'ctsetup' 'Setting admin password.'
passwd adryd

log 3 'ctsetup' 'Setup fail2ban.'
cp -f $AR_DIR/modules/fail2ban/jail.local /etc/fail2ban/jail.local
chmod 644 /etc/fail2ban/jail.local # just to be sure
systemctl enable fail2ban

log 3 'ctsetup' 'Installing AUR package manager'
sudo -u adryd git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
sudo -u adryd makepkg -si

log 3 'ctsetup' 'Adding ubuntu keyserver'
# lazy ill add this later
