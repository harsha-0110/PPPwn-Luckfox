#!/bin/sh

# Define the path to the configuration file
CONFIG_FILE="/etc/pppwn/config.json"

# Read configuration values from config.json
FW_VERSION=$(jq -r '.FW_VERSION' $CONFIG_FILE)
HEN_TYPE=$(jq -r '.HEN_TYPE' $CONFIG_FILE)
TIMEOUT=$(jq -r '.TIMEOUT' $CONFIG_FILE)
WAIT_AFTER_PIN=$(jq -r '.WAIT_AFTER_PIN' $CONFIG_FILE)
GROOM_DELAY=$(jq -r '.GROOM_DELAY' $CONFIG_FILE)
BUFFER_SIZE=$(jq -r '.BUFFER_SIZE' $CONFIG_FILE)
AUTO_RETRY=$(jq -r '.AUTO_RETRY' $CONFIG_FILE)
NO_WAIT_PADI=$(jq -r '.NO_WAIT_PADI' $CONFIG_FILE)
REAL_SLEEP=$(jq -r '.REAL_SLEEP' $CONFIG_FILE)
DIR=$(jq -r '.install_dir' $CONFIG_FILE)

# Define the paths to the stage1 and stage2 payloads based on FW_VERSION
STAGE1_PAYLOAD="$DIR/stage1/${FW_VERSION}/stage1.bin"
STAGE2_PAYLOAD="$DIR/stage2/${HEN_TYPE}/${FW_VERSION}/stage2.bin"

# Run pppwn with the configuration values
CMD="$DIR/pppwn --interface eth0 --fw $FW_VERSION --stage1 $STAGE1_PAYLOAD --stage2 $STAGE2_PAYLOAD"

# Append optional parameters
[ "$TIMEOUT" != "null" ] && CMD="$CMD --timeout $TIMEOUT"
[ "$WAIT_AFTER_PIN" != "null" ] && CMD="$CMD --wait-after-pin $WAIT_AFTER_PIN"
[ "$GROOM_DELAY" != "null" ] && CMD="$CMD --groom-delay $GROOM_DELAY"
[ "$BUFFER_SIZE" != "null" ] && CMD="$CMD --buffer-size $BUFFER_SIZE"
[ "$AUTO_RETRY" == "true" ] && CMD="$CMD --auto-retry"
[ "$NO_WAIT_PADI" == "true" ] && CMD="$CMD --no-wait-padi"
[ "$REAL_SLEEP" == "true" ] && CMD="$CMD --real-sleep"

# Reset the interface eth0
reset_interface() {
    ifconfig eth0 down
    sleep 1
    ifconfig eth0 up
    sleep 1
}

#Stop pppoe server
killall pppoe-server
reset_interface

# Execute the command
$CMD

# Start PPPoE server
echo "Starting PPPoE server..."
reset_interface
pppoe-server -I eth0 -T 60 -N 1 -C isp -S isp -L 10.1.1.1 -R 10.1.1.2 &
