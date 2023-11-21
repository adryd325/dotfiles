# TODO

## Meta
 - Centralized and shared nix and nixos configs
 - Write new script selection and meta system

/modules/install.sh
```bash
#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
```

/modules/meta.sh
```bash
#!/usr/bin/env bash
OSES=["macos" "linux"]
REQUIRES=["asdf"]
```

/systems/popsicle.sh
```bash
#!/usr/bin/env bash
REQUIRES=["bash" "discord" "etc"]
SYSTEM_PACKAGES=["bash" "etc"]
```

## Hosts

### popsicle
 - tlp and throttled configs
 - fprintd pam configs
 - automatically create swap partition/file for btrfs
