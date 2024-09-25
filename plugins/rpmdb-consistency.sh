#!/bin/bash

run_checks() {
	# check rpm DB itself (need to override lock path, the default one is read-only)
	rpm -D "%_rpmlock_path /run/rpmdb" --verifydb || exit 1
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
