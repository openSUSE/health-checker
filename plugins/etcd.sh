#!/bin/bash

run_checks() {
    # ignore if etcd is not enabled.
    systemctl is-enabled -q etcd
    test $? -ne 0 && return

    systemctl is-failed -q etcd
    test $? -ne 1 && exit 1

    curl -s http://localhost:2379/version > /dev/null
    test $? -ne 0 && exit 1
}

stop_services() {
    systemctl stop etcd
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
