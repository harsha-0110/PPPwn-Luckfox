#!/bin/sh

# Define the path to the configuration file
CONFIG_FILE="/etc/pppwn/config.json"

# Read configuration values
PPPWN=$(jq -r '.PPPWN' $CONFIG_FILE)
FW_VERSION=$(jq -r '.FW_VERSION' $CONFIG_FILE)
HEN_TYPE=$(jq -r '.HEN_TYPE' $CONFIG_FILE)
TIMEOUT=$(jq -r '.TIMEOUT' $CONFIG_FILE)
WAIT_AFTER_PIN=$(jq -r '.WAIT_AFTER_PIN' $CONFIG_FILE)
GROOM_DELAY=$(jq -r '.GROOM_DELAY' $CONFIG_FILE)
BUFFER_SIZE=$(jq -r '.BUFFER_SIZE' $CONFIG_FILE)
AUTO_RETRY=$(jq -r '.AUTO_RETRY' $CONFIG_FILE)
NO_WAIT_PADI=$(jq -r '.NO_WAIT_PADI' $CONFIG_FILE)
REAL_SLEEP=$(jq -r '.REAL_SLEEP' $CONFIG_FILE)
AUTO_START=$(jq -r '.AUTO_START' $CONFIG_FILE)
DIR=$(jq -r '.install_dir' $CONFIG_FILE)

# Define the paths to the stage1 and stage2 payloads based on FW_VERSION
STAGE1_PAYLOAD="$DIR/stage1/${FW_VERSION}/stage1.bin"
STAGE2_PAYLOAD="$DIR/stage2/${HEN_TYPE}/${FW_VERSION}/stage2.bin"

# Run pppwn with the configuration values
CMD="$DIR/$PPPWN --interface eth0 --fw $FW_VERSION --stage1 $STAGE1_PAYLOAD --stage2 $STAGE2_PAYLOAD"

# Append optional parameters
[ "$TIMEOUT" != "null" ] && CMD="$CMD --timeout $TIMEOUT"
[ "$WAIT_AFTER_PIN" != "null" ] && CMD="$CMD --wait-after-pin $WAIT_AFTER_PIN"
[ "$GROOM_DELAY" != "null" ] && CMD="$CMD --groom-delay $GROOM_DELAY"
[ "$BUFFER_SIZE" != "null" ] && CMD="$CMD --buffer-size $BUFFER_SIZE"
[ "$AUTO_RETRY" == "true" ] && CMD="$CMD --auto-retry"
[ "$NO_WAIT_PADI" == "true" ] && CMD="$CMD --no-wait-padi"
[ "$REAL_SLEEP" == "true" ] && CMD="$CMD --real-sleep"

#PPPwn Execution
if [ "$AUTO_START" = "true" ]; then
    #Stop pppoe server
    killall pppoe-server
    $CMD
else
    echo "Auto Start is disabled, Skipping PPPwn..."
fi

# Start PPPoE server
echo "Starting PPPoE server..."
pppoe-server -I eth0 -T 60 -N 1 -C isp -S isp -L 10.1.1.1 -R 10.1.1.2 -F &

# Function to read configuration values
read_config() {
    WEB_RUN=$(jq -r '.WEB_RUN' $CONFIG_FILE)
    SHUTDOWN=$(jq -r '.SHUTDOWN' $CONFIG_FILE)
}

# Function to update configuration values
update_config() {
    jq --argjson web_run "$1" --argjson shutdown "$2" '.WEB_RUN = $web_run | .SHUTDOWN = $shutdown' $CONFIG_FILE > /tmp/config.json && mv /tmp/config.json $CONFIG_FILE
}

BASE_LOCK_DIR="/tmp"
WEB_RUN_LOCK_FILE="$BASE_LOCK_DIR/web_run.lock"
SHUTDOWN_LOCK_FILE="$BASE_LOCK_DIR/shutdown.lock"

monitor_config() {
    while true; do
        if [ -f "$WEB_RUN_LOCK_FILE" ]; then
            echo "WEB_RUN lock file detected, executing web-run.sh..."
            rm "$WEB_RUN_LOCK_FILE"
            $DIR/web-run.sh
        fi

        if [ -f "$SHUTDOWN_LOCK_FILE" ]; then
            echo "SHUTDOWN lock file detected, halting the system..."
            rm "$SHUTDOWN_LOCK_FILE"
            halt -f
        fi
        
        sleep 2
    done
}

# Start monitoring in the background
monitor_config &
