#!/bin/bash

run_checks() {
    MOUNTS=`grep "btrfs.*subvol=" /etc/fstab | awk '{print $2}'`
    for i in ${MOUNTS}; do
        path=$(systemd-escape -p "$(echo -e ${i})")
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
