#!/bin/bash

# Variables
FW_VERSION="1100"  # Update this as needed
TIMEOUT="10"       # Update this as needed

# Run pppwn
pppwn --interface en0 --fw $FW_VERSION --stage1 "stage1/stage1_${FW_VERSION}.bin" --stage2 "stage2/stage2_${FW_VERSION}.bin" --timeout $TIMEOUT --auto-retry

# Start PPPoE server if pppwn is successful
if [ $? -eq 0 ]; then
    echo "pppwn executed successfully, starting PPPoE server..."
    sudo pppoe-server -C pppoe -L 192.168.1.1 -R 192.168.1.10 -N 4
else
    echo "pppwn failed, not starting PPPoE server."
fi
