#!/bin/bash

run_checks() {
}

disable_services() {
}

case "$1" in
    check)
	run_checks
	;;
    disable)
	disable_services
	;;
    *)
	echo "Usage: $0 {check|disable}"
	exit 1
	;;
esac

exit 0
