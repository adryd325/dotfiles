#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/logger.sh

arCtDebianInstallAdminUser=adryd
arCtDebianInstallServicesUser=adryd-services

log 3 'ctsetup' 'Updating packages'
apt-get update -qq &> $AR_TTY
apt-get upgrade -qq &> $AR_TTY

id $arCtDebianInstallAdminUser &> $AR_TTY
if [[ $? -eq 1 ]]; then
    log 3 'ctsetup' 'Creating admin user'
    useradd -mG sudo $arCtDebianInstallAdminUser
    log 3 'ctsetup' 'Setting admin password'
    passwd $arCtDebianInstallAdminUser
    log 3 'ctsetup' 'Setting default shell'
    usermod $arCtDebianInstallAdminUser -s /bin/bash
fi

id $arCtDebianInstallServicesUser &> $AR_TTY
if [[ $? -eq 1 ]]; then
    log 3 'ctsetup' 'Creating services user'
    useradd $arCtDebianInstallServicesUser
    log 3 'ctsetup' 'Adding admin user to services group'
    usermod -aG $arCtDebianInstallServicesUser $arCtDebianInstallAdminUser
fi

log 3 'ctsetup' 'Configuring SSH'
arCtDebianInstallSshConfig=/etc/ssh/sshd_config
grep "# .ADRYD LOCK" $arCtDebianInstallSshConfig > /dev/null
if [[ $? -eq 1 ]]; then
    echo '# .ADRYD LOCK (this is to prevent the deploy script from infinitely appending this config to the end of the file)' >> $arCtDebianInstallSshConfig
    echo 'PermitRootLogin no' >> $arCtDebianInstallSshConfig
    echo 'GSSAPIAuthentication no' >> $arCtDebianInstallSshConfig
    echo 'PasswordAuthentication no' >> $arCtDebianInstallSshConfig
    echo 'PermitEmptyPasswords no' >> $arCtDebianInstallSshConfig
    echo 'UsePAM no' >> $arCtDebianInstallSshConfig
    echo "AllowUsers $arCtDebianInstallAdminUser" >> $arCtDebianInstallSshConfig
    echo 'AuthenticationMethods publickey' >> $arCtDebianInstallSshConfig
else
    log 4 'ctsetup' 'SSH config already exists'
fi
log 3 'ctsetup' 'Reloading SSH' 
systemctl reload ssh > $AR_TTY # this package/service naming clusterfuck has to stop

if [[ ! -e /home/$arCtDebianInstallAdminUser/.ssh/authorized_keys ]]; then
    log 3 'ctsetup' 'Installing SSH key'
    mkdir -p /home/$arCtDebianInstallAdminUser/.ssh
    mv /root/.ssh/authorized_keys /home/$arCtDebianInstallAdminUser/.ssh/authorized_keys
    rm -r /root/.ssh # empty directory now
    chown $arCtDebianInstallAdminUser:$arCtDebianInstallAdminUser -R /home/$arCtDebianInstallAdminUser/.ssh
fi

log 3 'ctsetup' 'Locking root user'
# All this is "just in case", hence why it's dissabled in 4 ways
cat /dev/urandom | tr -dc A-Za-z0-9 | head -c${1:-128} | passwd root --stdin &> $AR_TTY
passwd -l root &> $AR_TTY
chage -E 0 root &> $AR_TTY

if [[ ! -x "$(command -v curl)" ]]; then
    log 3 'ctsetup' 'Installing curl'
    apt-get install curl -qqy &> $AR_TTY
fi

if [[ ! -x "$(command -v sudo)" ]]; then
    log 3 'ctsetup' 'Installing sudo'
    apt-get install sudo -qqy &> $AR_TTY
fi

if [[ ! -x "$(command -v git)" ]]; then
    log 3 'ctsetup' 'Installing git'
    apt-get install git -qqy &> $AR_TTY
fi

if [[ ! -e /etc/fail2ban/jail.local ]]; then
    log 3 'ctsetup' 'Installing fail2ban'
    apt-get install fail2ban -qqy &> $AR_TTY
    log 3 'ctsetup' 'Copying fail2ban configuration'
    cp $AR_DIR/extra/lemon/lxcs/fail2ban/jail.local /etc/fail2ban/jail.local
    chmod 644 /etc/fail2ban/jail.local # just to be sure
    log 3 'ctsetup' 'Enaling fail2ban'
    systemctl enable fail2ban &> $AR_TTY
fi

log 3 'ctsetup' 'Trusting internal CA'
cp -f $AR_DIR/extra/general/root-ca.pem /usr/local/share/ca-certificates/adryd-root-ca.crt
update-ca-certificates &> $AR_TTY

log 3 'ctsetup' 'Placing manual in home directory'
touch /home/$arCtDebianInstallAdminUser/manual.txt
chown $arCtDebianInstallAdminUser:$arCtDebianInstallAdminUser /home/$arCtDebianInstallAdminUser/manual.txt

log 3 'ctsetup' 'Cleaning up'
rm -rf $AR_DIR