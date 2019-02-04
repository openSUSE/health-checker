#!/bin/bash

run_checks() {
    # ignore if kubelet is not enabled.
    systemctl is-enabled -q kubelet
    test $? -ne 0 && return

    systemctl is-failed -q kubelet
    test $? -ne 1 && exit 1
}

stop_services() {
    systemctl stop kubelet
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
