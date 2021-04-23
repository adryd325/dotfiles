#!/bin/bash
source $HOME/.adryd/constants.sh
AR_MODULE="ctsetup"

adminUser=adryd
servicesUser=adryd-services

log info "Updating packages"
apt-get update -qq &> /dev/null
apt-get upgrade -qq &> /dev/null

if ! id $adminUser &> /dev/null; then
    log info "Creating admin user"
    useradd -mG sudo $adminUser
    log info "Setting admin password"
    passwd $adminUser
    log info "Setting default shell"
    usermod $adminUser -s /bin/bash
fi

if ! id $servicesUser ; then
    log info "Creating services user"
    useradd $servicesUser
    log info "Adding admin user to services group"
    usermod -aG $servicesUser $adminUser
fi

log info "Configuring SSH"
sshConfig=/etc/ssh/sshd_config
grep "# .ADRYD LOCK" $sshConfig > /dev/null
if [[ $? -eq 1 ]]; then
    echo "# .ADRYD LOCK (this is to prevent the deploy script from infinitely appending this config to the end of the file)" >> $sshConfig
    echo "PermitRootLogin no" >> $sshConfig
    echo "GSSAPIAuthentication no" >> $sshConfig
    echo "PasswordAuthentication no" >> $sshConfig
    echo "PermitEmptyPasswords no" >> $sshConfig
    echo "UsePAM no" >> $sshConfig
    echo "AllowUsers $adminUser" >> $sshConfig
    echo "AuthenticationMethods publickey" >> $sshConfig
else
    log warn "SSH config already exists"
fi

log info "Reloading SSH" 
systemctl reload ssh > /dev/null # this package/service naming clusterfuck has to stop

if [[ ! -e /home/$adminUser/.ssh/authorized_keys ]]; then
    log info "Installing SSH key"
    mkdir -p /home/$adminUser/.ssh
    mv /root/.ssh/authorized_keys /home/$adminUser/.ssh/authorized_keys
    rm -r /root/.ssh # empty directory now
    chown $adminUser:$adminUser -R /home/$adminUser/.ssh
fi

log info "Locking root user"
cat /dev/urandom | tr -dc A-Za-z0-9 | head -c${1:-128} | passwd root --stdin &> /dev/null
passwd -l root &> /dev/null
chage -E 0 root &> /dev/null

if [ ! -e "$(command -v curl)" ]; then
    log info "Installing curl"
    apt-get install curl -qqy &> /dev/null
fi

if [ ! -e "$(command -v sudo)" ]; then
    log info "Installing sudo"
    apt-get install sudo -qqy &> /dev/null
fi

if [ ! -e "$(command -v git)" ]; then
    log info "Installing git"
    apt-get install git -qqy &> /dev/null
fi

if [ ! -e /etc/fail2ban/jail.local ]; then
    log info'Installing fail2ban'
    apt-get install fail2ban -qqy &> $AR_TTY
    log info 'Copying fail2ban configuration'
    cp $AR_DIR/systems/server/vms/fail2ban/jail.local /etc/fail2ban/jail.local
    chmod 644 /etc/fail2ban/jail.local # just to be sure
    log info 'Enaling fail2ban'
    systemctl enable fail2ban &> $AR_TTY
fi

log info "Trusting internal CA"
cp -f $AR_DIR/systems/server/vms/root-ca.pem /usr/local/share/ca-certificates/adryd-root-ca.crt
update-ca-certificates &> $AR_TTY

log info "Placing manual in home directory"
touch /home/$adminUser/manual.txt
chown $adminUser:$adminUser /home/$adminUser/manual.txt

log info "Cleaning up"
rm -rf $AR_DIR