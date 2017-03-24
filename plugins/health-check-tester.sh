#!/bin/bash

#
# plugin to test basic functionality of CaaSP health checker
#

run_checks() {

# Simple check: if this is the very first boot, succeed.
# If not, fail.
   if [ -f /var/lib/misc/health-check.state ]; then
       exit 1
   else
       return 0
   fi
}

stop_services() {
    exit 1
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
