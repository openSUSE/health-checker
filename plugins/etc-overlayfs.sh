#!/bin/bash

# Check if the overlay filesystem for /etc is working correctly

run_checks() {
    systemctl is-failed etc.mount
    test $? -ne 1 && exit 1

    TMPF=$(mktemp -q /etc/test-for-read-write.XXXXXX) || exit 1
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
