#!/bin/bash

run_checks() {
    systemctl is-enabled -q systemd-logind
    test $? -ne 0 && return

    systemctl is-failed -q systemd-logind
    test $? -ne 1 && exit 1
}

stop_services() {
    systemctl stop systemd-logind
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
