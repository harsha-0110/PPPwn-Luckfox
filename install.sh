#!/bin/sh

# Define variables
CURRENT_DIR=$(pwd)
DEFAULT_CONFIG_FILE=$CURRENT_DIR/config/pppwn/config.ini.default
TARGET_DIR=/etc/pppwn
CONFIG_FILE=$TARGET_DIR/config.ini
WEB_DIR=/var/www/pppwn
PPPWN_SERVICE=S99pppwn-service

# Change permissions for the scripts and executables
chmod +x ./bin/*

# Create target directory if it doesn't exist
mkdir -p $TARGET_DIR 2>&1

# Create configuration file if it doesn't exist
touch $CONFIG_FILE

TEMP_FILE=$(mktemp)
# Combine defaults with the target config, giving priority to target values
{
    # Read the target config file (CONFIG_FILE) first to ensure its values are prioritized
    while IFS='=' read -r key value; do
        [[ -n "$key" && -n "$value" ]] && echo "$key=$value"
    done < $CONFIG_FILE

    # Read the defaults config file (DEFAULT_CONFIG_FILE) and include only missing entries
    while IFS='=' read -r key value; do
        [[ -n "$key" && -n "$value" ]] && ! grep -q "^$key=" $CONFIG_FILE && echo "$key=$value"
    done < $DEFAULT_CONFIG_FILE
} > $TEMP_FILE

# Replace the target config file with the merged result
mv $TEMP_FILE $CONFIG_FILE

# make it writeable by nginx & php
chown www-data $CONFIG_FILE

# Link the web directory
rm -rf $WEB_DIR > /dev/null 2>&1
ln -s $CURRENT_DIR/web $WEB_DIR
chmod -R 755 $WEB_DIR

# Cleanup previous installs and link the scripts
rm -rf $TARGET_DIR/*.sh > /dev/null 2>&1
for script in bin/*; do
    rm -rf $TARGET_DIR/$(basename $script) > /dev/null 2>&1
    ln -s $CURRENT_DIR/$script $TARGET_DIR
done

# Link the service
rm -rf /etc/init.d/$PPPWN_SERVICE > /dev/null 2>&1
ln -s $TARGET_DIR/$PPPWN_SERVICE /etc/init.d/

# Link the stages
rm -rf $TARGET_DIR/stage* > /dev/null 2>&1
ln -s $CURRENT_DIR/stage1 $TARGET_DIR
ln -s $CURRENT_DIR/stage2 $TARGET_DIR

# Setup configurations
cp -pr $CURRENT_DIR/config/* /etc

echo "Installation complete. Rebooting!"

reboot -f
