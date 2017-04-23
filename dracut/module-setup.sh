#!/bin/bash

# called by dracut
check() {
    require_binaries logger date || return 1
}

# called by dracut
depends() {
    echo drm
}

# called by dracut
install() {
    inst_hook emergency 90 "$moddir"/health-checker-emergency.sh

    inst_multiple date btrfs awk
}

