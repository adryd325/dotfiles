#!/bin/bash
arCtFedoraInstallAdminUser=adryd

source $AR_DIR/lib/logger.sh
log 3 'ctsetup' 'Updating packages.'
dnf update -qy
id $arCtFedoraInstallAdminUser > $AR_TTY
if [[ $? -eq 0 ]]; then
    log 3 'ctsetup' 'Creating admin user.'
    useradd -mG wheel $arCtFedoraInstallAdminUser
    log 3 'ctsetup' 'Setting admin password.'
    passwd $arCtFedoraInstallAdminUser
fi

log 3 'ctsetup' 'Installing SSH.'
dnf install openssh-server -qy
log 3 'ctsetup' 'Configuring SSH.'
arCtFedoraInstallSshConfig=/etc/ssh/sshd_config.d/80-adryd.conf
if [[ ! -e $arCtFedoraInstallSshConfig ]]; then
    echo 'PermitRootLogin no' >> $arCtFedoraInstallSshConfig
    echo 'GSSAPIAuthentication no' >> $arCtFedoraInstallSshConfig
    echo 'PasswordAuthentication no' >> $arCtFedoraInstallSshConfig
    echo 'PermitEmptyPasswords no' >> $arCtFedoraInstallSshConfig
    echo 'UsePAM no' >> $arCtFedoraInstallSshConfig
    echo "AllowUsers $arCtFedoraInstallAdminUser" >> $arCtFedoraInstallSshConfig
    echo 'AuthenticationMethods publickey' >> $arCtFedoraInstallSshConfig
else
    log 4 'ctsetup' 'SSH config already exists.'
fi
log 3 'ctsetup' 'Enabling SSH.' 
systemctl enable --now sshd > $AR_TTY # this package/service naming clusterfuck has to stop

if [[ -e /home/$arCtFedoraInstallAdminUser/.ssh/authorized_keys ]]; then
    log 3 'ctsetup' 'Installing SSH key.'
    mkdir -p /home/$arCtFedoraInstallAdminUser/.ssh
    mv /root/.ssh/authorized_keys /home/$arCtFedoraInstallAdminUser/.ssh/authorized_keys
    rm -r /root/.ssh # empty directory now
    chown $arCtFedoraInstallAdminUser:$arCtFedoraInstallAdminUser -R /home/$arCtFedoraInstallAdminUser/.ssh
fi

log 3 'ctsetup' 'Installing development tools.'
dnf install @development-tools -qy
log 3 'ctsetup' 'Swap text editors.'
dnf remove vim-minimal -qy
dnf install nano -qy
git config --global core.editor nano

log 3 'ctsetup' 'Locking root user.'
# All this is "just in case", hence why it's dissabled in 3 ways
cat /dev/urandom | tr -dc A-Za-z0-9 | head -c${1:-128} | passwd root --stdin &> $AR_TTY
passwd -l root &> $AR_TTY
chage -E 0 root &> $AR_TTY

if [[ ! -e /etc/fail2ban/jail.local ]]; then
    log 3 'ctsetup' 'Installing fail2ban.'
    dnf install fail2ban -qy 
    log 3 'ctsetup' 'Copying fail2ban configuration.'
    cp $AR_DIR/modules/fail2ban/jail.local /etc/fail2ban/jail.local
    chmod 644 /etc/fail2ban/jail.local # just to be sure
    log 3 'ctsetup' 'Enaling fail2ban.'
    systemctl enable fail2ban > $AR_TTY
fi

log 3 'ctsetup' 'Trusting internal CA.'
curl -fsSL https://adryd.co/root-ca.pem > /tmp/root-ca.pem
trust anchor --store /tmp/root-ca.pem
rm /tmp/root-ca.pem

log 3 'ctsetup' 'Placing manual in home directory.'
touch /home/$arCtFedoraInstallAdminUser/manual.txt
chown $arCtFedoraInstallAdminUser:$arCtFedoraInstallAdminUser manual.txt

log 3 'ctsetup' 'Cleaning up.'
rm -rf $AR_DIR