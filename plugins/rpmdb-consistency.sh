#!/bin/bash

run_checks() {
	zypper --no-refresh --quiet verify --dry-run
	test $? -ne 0 && exit 1
}

case "$1" in
    check)
	run_checks
	;;
    stop)
	;;
    *)
	echo "Usage: $0 {check|stop}"
	exit 1
	;;
esac

exit 0
