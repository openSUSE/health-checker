#!/bin/bash

run_checks() {
    MOUNTS=$(findmnt --types btrfs --options subvol --fstab --output target --raw --noheadings)
    for i in ${MOUNTS}; do
        path=$(systemd-escape -p -- "$(echo -e ${i})")
        systemctl is-failed -q "${path}.mount"
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
