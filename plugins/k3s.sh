#!/bin/bash

run_checks() {
    # ignore if k3s is not enabled.
    systemctl is-enabled -q k3s
    test $? -ne 0 && return

    systemctl is-failed -q k3s
    test $? -ne 1 && exit 1

    kubectl cluster-info
    test $? -ne 0 && exit 1
}

stop_services() {
    systemctl stop k3s
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
