#!/bin/bash

# Check if tmp is mounted and writable
run_checks() {
    systemctl is-failed -q tmp.mount
    test $? -ne 1 && exit 1

    TMPF=$(mktemp -q /tmp/test-for-read-write.XXXXXX) || exit 1
    rm ${TMPF}
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
