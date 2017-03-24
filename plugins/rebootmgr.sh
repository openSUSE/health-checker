#!/bin/bash

run_checks() {
    # ignore if rebootmgr is not enabled.
    systemctl is-enabled -q rebootmgr
    test $? -ne 0 && return

    systemctl is-failed -q rebootmgr
    test $? -ne 1 && exit 1

    rebootmgrctl is-active -q
    test $? -ne 0 && exit 1
}

stop_services() {
    systemctl stop rebootmgr
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
