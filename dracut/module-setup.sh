#!/bin/bash

# called by dracut
check() {
    if [ ! -x /bin/sdbootutil ]; then
        require_binaries logger date || return 1
    fi
}

# called by dracut
depends() {
    if [ ! -x /bin/sdbootutil ]; then
        echo drm
    fi
}

# called by dracut
install() {
    if [ ! -x /bin/sdbootutil ]; then
        inst_hook emergency 90 "$moddir"/health-checker-emergency.sh

        inst_multiple date btrfs awk grub2-editenv
    fi
}

