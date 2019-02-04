#!/bin/bash

run_checks() {
    # Check first if it is installed:
    rpm -q --quiet crio
    test $? -ne && return

    # ignore if crio is not enabled.
    systemctl is-enabled -q crio
    test $? -ne 0 && return

    systemctl is-failed -q crio
    test $? -ne 1 && exit 1
}

stop_services() {
    systemctl stop crio
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
