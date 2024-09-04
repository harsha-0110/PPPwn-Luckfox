#!/bin/sh

# Define variables
CURRENT_DIR=$(pwd)
WEB_DIR="/var/www/pppwn"
NGINX_CONF="/etc/nginx/nginx.conf"
PPPWN_SERVICE="/etc/init.d/pppwn"
CONFIG_DIR="/etc/pppwn"
CONFIG_FILE="$CONFIG_DIR/config.json"

BIN_DIR="$CURRENT_DIR/bin"
PPPWN_SERVICE="S99pppwn-service"

# Default configuration values
DEFAULT_CONFIG=$(cat <<EOF
{
    "PPPWN": "pppwn2",
    "FW_VERSION": "1100",
    "HEN_TYPE": "goldhen",
    "TIMEOUT": "5",
    "WAIT_AFTER_PIN": "2",
    "GROOM_DELAY": "4",
    "BUFFER_SIZE": "0",
    "AUTO_RETRY": true,
    "NO_WAIT_PADI": true,
    "REAL_SLEEP": false,
    "AUTO_START": false,
    "SPRAY_NUM": "4096",
    "PIN_NUM": "4096",
    "CORRUPT_NUM": "1",
    "OLD_IPv6": false,
    "install_dir": "$CURRENT_DIR"
}
EOF
)

# Function to check and add missing keys
update_config() {
    for key in $(echo "$DEFAULT_CONFIG" | jq -r 'keys[]'); do
        # always update install_dir
        if [ "${key}" = "install_dir" ] || ! jq -e ".${key}" "$CONFIG_FILE" > /dev/null; then
            value=$(echo "$DEFAULT_CONFIG" | jq ".${key}")
            jq ".${key} = ${value}" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
        fi
    done
}

# Change permissions of the following files
chmod +x ./bin/*

# Create configuration directory if it doesn't exist
mkdir -p $CONFIG_DIR 2>&1

# Create or update the pppwn.json file
if [ ! -f "$CONFIG_FILE" ]; then
    echo "$DEFAULT_CONFIG" | jq '.' > "$CONFIG_FILE"
    chmod 766 $CONFIG_FILE
else
    update_config
    chmod 777 $CONFIG_FILE
fi

# Remove the web directory if it already exists
rm -rf $WEB_DIR > /dev/null 2>&1

# Set up the web directory
mkdir -p $WEB_DIR
cp -r $CURRENT_DIR/web/* $WEB_DIR/
chmod -R 755 $WEB_DIR

# Create PPPwn service
rm -rf $CONFIG_DIR/*.sh > /dev/null 2>&1
for script in bin/*; do
    rm -rf $CONFIG_DIR/$(basename $script) > /dev/null 2>&1
    ln -s $CURRENT_DIR/$script $CONFIG_DIR
done
rm -rf /etc/init.d/$PPPWN_SERVICE > /dev/null 2>&1
ln -s $CONFIG_DIR/$PPPWN_SERVICE /etc/init.d/

# Set up configurations
cp -pr $CURRENT_DIR/config/ppp /etc
cp -pr $CURRENT_DIR/config/nginx /etc

echo "Installation complete. Rebooting!"

# reboot -f