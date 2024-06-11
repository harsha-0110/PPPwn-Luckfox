#!/bin/bash

# Define the path to the configuration file
CONFIG_FILE="/etc/pppwn/config.json"

# Read configuration values from config.json
FW_VERSION=$(jq -r '.FW_VERSION' $CONFIG_FILE)
TIMEOUT=$(jq -r '.TIMEOUT' $CONFIG_FILE)
WAIT_AFTER_PIN=$(jq -r '.WAIT_AFTER_PIN' $CONFIG_FILE)
GROOM_DELAY=$(jq -r '.GROOM_DELAY' $CONFIG_FILE)
BUFFER_SIZE=$(jq -r '.BUFFER_SIZE' $CONFIG_FILE)
AUTO_RETRY=$(jq -r '.AUTO_RETRY' $CONFIG_FILE)
NO_WAIT_PADI=$(jq -r '.NO_WAIT_PADI' $CONFIG_FILE)
REAL_SLEEP=$(jq -r '.REAL_SLEEP' $CONFIG_FILE)
DIR=$(jq -r '.install_dir' $CONFIG_FILE)
GOLDHEN_MOUNT=$(jq -r '.GOLDHEN_MOUNT' $CONFIG_FILE)

# Define the paths to the stage1 and stage2 payloads based on FW_VERSION
STAGE1_PAYLOAD="$DIR/stage1/stage1_${FW_VERSION}.bin"
STAGE2_PAYLOAD="$DIR/stage2/stage2_${FW_VERSION}.bin"

# Function to emulate USB drive
emulate_usb_drive() {
    # Create a disk image file
    USB_IMG="/tmp/goldhen.img"
    dd if=/dev/zero of=$USB_IMG bs=1M count=16
    mkfs.vfat $USB_IMG

    # Mount the image and copy goldhen.bin
    MOUNT_DIR="/mnt/goldhen"
    mkdir -p $MOUNT_DIR
    sudo mount -o loop $USB_IMG $MOUNT_DIR
    sudo cp .$DIR/goldhen/goldhen.bin $MOUNT_DIR
    sudo umount $MOUNT_DIR

    # Load the g_mass_storage module
    sudo modprobe g_mass_storage file=$USB_IMG stall=0
}

# Function to clean up USB drive emulation
cleanup_usb_drive() {
    # Unload the g_mass_storage module
    sudo rmmod g_mass_storage

    # Remove the temporary image file
    rm -f /tmp/goldhen.img
}

# Check if GOLDHEN_MOUNT is true and emulate USB drive
if [ "$GOLDHEN_MOUNT" == "true" ]; then
    echo "GOLDHEN_MOUNT is true, emulating USB drive with goldhen.bin..."
    emulate_usb_drive
fi

# Run pppwn with the configuration values
CMD="$DIR/pppwn --interface eth0 --fw $FW_VERSION --stage1 $STAGE1_PAYLOAD --stage2 $STAGE2_PAYLOAD"

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

# Start PPPoE server
echo "pppwn executed successfully, starting PPPoE server..."
sudo bash $DIR/pppoe.sh


# Cleanup USB drive if GOLDHEN_MOUNT was true
if [ "$GOLDHEN_MOUNT" == "true" ]; then
    echo "Cleaning up USB drive emulation..."
    cleanup_usb_drive
fi
