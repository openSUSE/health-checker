#!/bin/bash

run_checks() {
    # ignore if k3s-agent is not enabled.
    systemctl is-enabled -q k3s-agent
    test $? -ne 0 && return

    systemctl is-failed -q k3s-agent
    test $? -ne 1 && exit 1

    systemctl is-active -q k3s-agent
    test $? -ne 0 && exit 1
}

stop_services() {
    systemctl stop k3s-agent
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
