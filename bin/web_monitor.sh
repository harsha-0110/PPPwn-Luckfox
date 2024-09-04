#!/bin/bash

# Lockfile locations
WEB_RUN_LOCK_FILE="/tmp/web_run.lock"
SHUTDOWN_LOCK_FILE="/tmp/shutdown.lock"
ETHDOWN_LOCK_FILE="/tmp/eth_down.lock"
SERVICE="/etc/init.d/S99pppwn-service"

echo "Web monitor started..."

monitor_lockfile() {
    while true; do
        if [ -f "$WEB_RUN_LOCK_FILE" ]; then
            echo "WEB_RUN lock file detected, executing pppwn..."
            rm "$WEB_RUN_LOCK_FILE"
            eval "${SERVICE} --pppwn-only"
        fi

        if [ -f "$SHUTDOWN_LOCK_FILE" ]; then
            echo "SHUTDOWN lock file detected, halting the system..."
            rm "$SHUTDOWN_LOCK_FILE"
            halt -f
        fi

        if [ -f "$ETHDOWN_LOCK_FILE" ]; then
            echo "ETHDOWN lock file detected, powering down eth0..."
            rm "$ETHDOWN_LOCK_FILE"
            killall pppoe-server
            ifconfig eth0 down
        fi
        sleep 2
    done
}

monitor_lockfile