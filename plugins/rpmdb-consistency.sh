#!/bin/bash

run_checks() {
	# check rpm DB itself
	rpm -D "%_rpmlock_path /run/rpmdb"  --verifydb
	test $? -ne 0 && exit 1
	# only rely on local/system repository for check
	zypper --no-refresh --no-remote --non-interactive --quiet verify --dry-run
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
