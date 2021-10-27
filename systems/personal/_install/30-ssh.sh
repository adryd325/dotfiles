#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="ssh"

if [[ "${AR_OS}" = "linux_arch" ]]; then
    if [[ ! -d "${HOME}/.ssh" ]]; then
        mkdir "${HOME}/.ssh"
    fi
    if [[ ! -f "${HOME}/.ssh/id_ed25519" ]] > /dev/null; then
        if ar_keyring && [[ -n "${AR_KEYRING}" ]]; then
            log info "Copying ssh configs and keys from keyring"
            cp "${AR_KEYRING}"/ssh/* "${HOME}/.ssh"
        fi
    fi
    if ! grep "# .ADRYD LOCK (${AR_MODULE})" /etc/ssh/sshd_config > /dev/null; then
        log info "Applying sshd_config"
        sudo tee -a /etc/ssh/sshd_config > /dev/null <<EOF
# .ADRYD LOCK (${AR_MODULE}) (this is to prevent the deploy script from infinitely appending this config to the end of the file)
PermitRootLogin no
GSSAPIAuthentication no
PasswordAuthentication no
PermitEmptyPasswords no
AllowUsers ${USER}
AuthenticationMethods publickey
EOF
    fi
    sudo systemctl enable --now sshd > /dev/null
fi
