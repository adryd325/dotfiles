#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../common/discord/versions.sh
source ../../lib/os.sh
source ../../lib/realpath.sh
source ../../lib/log.sh
export AR_MODULE="heckheating"

function patchBranch() {
    branch=$1
    AR_LOG_PREFIX="${branch}"
    name=$(getDiscordName "${branch}")
    prettyName=$(getDiscordPrettyName "${branch}")

    log info "Patching discord"
    if [[ "$(getKernel)" == "darwin" ]]; then
        node "${hhDir}/bin/cli.js" "/Applications/${prettyName}.app/Contents/MacOS/${prettyName}" > /dev/null
    else
        node "${hhDir}/bin/cli.js" "${HOME}/.local/share/${name}/${name}" > /dev/null
    fi
}

if [[ ! -x $(command -v node) ]]; then
    log error "nodejs isn't installed. Cannot proceed"
    exit 1
fi

if [[ ! -x $(command -v git) ]]; then
    log error "git isn't installed. Cannot proceed"
    exit 1
fi

hhDir="${HOME}/.local/share/hh3"
configDir="${HOME}/.config/hh3"
if [[ "$(getDistro)" == "macos" ]]; then
    hhDir="${HOME}/.hh3"
    configDir="${HOME}/Library/Application Support/hh3"
fi
# Clone the repo if we don't have it, and if we might have keys
if [[ ! -d "${hhDir}" ]] && [[ -e "${HOME}/.ssh" ]]; then
    log info "Cloning HH3"
    if ! git clone gitolite3@git.coolmathgames.tech:/hh3.git "${hhDir}" --quiet; then
        log error "Failed to clone HH3, likely a permission issue"
        exit 1;
    fi
else
    log info "Pulling latest changes"
    git pull --ff-only --quiet
fi

if [[ ! -e "${configDir}" ]]; then
    log info "Linking config folder"
    ln -s "$(realpath ./config)" "${configDir}"
fi

(
    cd "${hhDir}" || exit $?
    log info "Installing dependencies"
    pnpm install --recursive --silent
    cd "${hhDir}/web" || exit $?
    log info "Building webextension"
    node buildExtension.js &> /dev/null
)

for branch in "${DISCORD_BRANCHES[@]}"; do
    patchBranch "${branch}" &
done
wait
