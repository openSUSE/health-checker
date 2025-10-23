#!/bin/bash

#
# plugin to test basic functionality of MicroOS health checker
#

run_checks() {

   # Check if the system is running legacy grub as the check file
   # is only used there
   if [ -d /boot/efi/loader/entries ]; then
       return 0
   fi
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
