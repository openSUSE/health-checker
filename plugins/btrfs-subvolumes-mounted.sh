#!/bin/bash

run_checks() {

    MOUNTS=`grep "btrfs.*subvol=" /etc/fstab | awk '{print $2}' | sed -e 's|^/||g' -e 's|-|\\\x2d|g' -e 's|^\.|\\\x2e|g' -e 's|/|-|g'`
    for i in ${MOUNTS}; do
        systemctl is-failed -q $i.mount
        test $? -ne 1 && exit 1
    done
}

stop_services() {
    echo -n ""
}

case "$1" in
    check)
	run_checks
	;;
    stop)
	stop_services
	;;
    *)
	echo "Usage: $0 {check|stop}"
	exit 1
	;;
esac

exit 0
