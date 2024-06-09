#!/bin/bash

# Define the path to the configuration file
CONFIG_FILE="/etc/pppwn/config.json"

# Check if jq is installed, if not, install it
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Installing jq..."
    sudo apt-get update
    sudo apt-get install -y jq
fi

# Read configuration values from config.json
FW_VERSION=$(jq -r '.FW_VERSION' $CONFIG_FILE)
TIMEOUT=$(jq -r '.TIMEOUT' $CONFIG_FILE)
WAIT_AFTER_PIN=$(jq -r '.WAIT_AFTER_PIN' $CONFIG_FILE)
GROOM_DELAY=$(jq -r '.GROOM_DELAY' $CONFIG_FILE)
BUFFER_SIZE=$(jq -r '.BUFFER_SIZE' $CONFIG_FILE)
AUTO_RETRY=$(jq -r '.AUTO_RETRY' $CONFIG_FILE)
NO_WAIT_PADI=$(jq -r '.NO_WAIT_PADI' $CONFIG_FILE)
REAL_SLEEP=$(jq -r '.REAL_SLEEP' $CONFIG_FILE)

# Define the paths to the stage1 and stage2 payloads based on FW_VERSION
STAGE1_PAYLOAD="stage1/stage1_${FW_VERSION}.bin"
STAGE2_PAYLOAD="stage2/stage2_${FW_VERSION}.bin"

# Run pppwn with the configuration values
CMD="./pppwn --interface eth0 --fw $FW_VERSION --stage1 $STAGE1_PAYLOAD --stage2 $STAGE2_PAYLOAD"

# Append optional parameters
[ "$TIMEOUT" != "null" ] && CMD+=" --timeout $TIMEOUT"
[ "$WAIT_AFTER_PIN" != "null" ] && CMD+=" --wait-after-pin $WAIT_AFTER_PIN"
[ "$GROOM_DELAY" != "null" ] && CMD+=" --groom-delay $GROOM_DELAY"
[ "$BUFFER_SIZE" != "null" ] && CMD+=" --buffer-size $BUFFER_SIZE"
[ "$AUTO_RETRY" == "true" ] && CMD+=" --auto-retry"
[ "$NO_WAIT_PADI" == "true" ] && CMD+=" --no-wait-padi"
[ "$REAL_SLEEP" == "true" ] && CMD+=" --real-sleep"

# Execute the command
$CMD

# Start PPPoE server if pppwn is successful
if [ $? -eq 0 ]; then
    echo "pppwn executed successfully, starting PPPoE server..."
    sudo bash ./pppoe.sh
fi
