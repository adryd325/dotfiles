#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
[[ "${USER}" = "root" ]] && log error "Do not run as root" && exit 1
#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?

source ../../lib/log.sh
source ../../lib/os.sh

../../common/bash/_install.sh
../../common/update-global-installation.sh
../../common/bash/_install.sh globalInstall

# Update everything
sudo dnf upgrade

# ./install-packages.sh || exit $?
../../common/sysctl/_install.sh
../../common/xdg-user-dirs/_install.sh
../../common/mimeapps/_install.sh
../../common/hide-internal-apps/hide-internal-apps.sh
../../common/gnome-shell/_install.sh
../../common/gnome-terminal/_install.sh
../../common/vscode/_install.sh
../../common/discord/_install.sh "stable" "canary"
../../common/heckheating/_install.sh "stable" "canary"
../../common/discord/wmclass-fix.sh "stable" "canary"
