#!/bin/bash

# Define variables
CURRENT_DIR=$(pwd)
WEB_DIR="/var/www/pppwn"
NGINX_CONF="/etc/nginx/sites-available/default"
PPPWN_SERVICE="/etc/systemd/system/pppwn.service"
PPPOE_SERVICE="/etc/systemd/system/pppoe.service"
CONFIG_DIR="/etc/pppwn"
CONFIG_FILE="$CONFIG_DIR/config.json"

# Change permissions of the following files
sudo chmod +x ./pppwn
sudo chmod +x ./pppoe.sh
sudo chmod +x ./run.sh
sudo chmod +x ./update.sh
sudo chmod +x ./web-run.sh

# Create configuration directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
    sudo mkdir -p $CONFIG_DIR
fi

# Create the config.json file with the install directory if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    sudo tee $CONFIG_FILE > /dev/null <<EOL
{
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
    "install_dir": "$CURRENT_DIR"
}
EOL
    sudo chmod 777 $CONFIG_FILE
fi

# Remove the web directory if it already exists
if [ -d "$WEB_DIR" ]; then
    sudo rm -rf $WEB_DIR
fi

# Set up the web directory
sudo mkdir -p $WEB_DIR
sudo cp -r $CURRENT_DIR/web/* $WEB_DIR/

# Give passwordless sudo access to www-data user
sudo sed -i "/www-data    ALL=(ALL) NOPASSWD: ALL/d" /etc/sudoers
echo 'www-data    ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers

# Detect the PHP-FPM version
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
PHP_FPM_SOCK="/var/run/php/php${PHP_VERSION}-fpm.sock"

# Set up Nginx configuration
sudo tee $NGINX_CONF > /dev/null <<EOL
server {
    listen 80 default_server;
    server_name _;

    root $WEB_DIR;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:$PHP_FPM_SOCK;
    }

    location ~ /\.ht {
        deny all;
    }

    location /some/path {
        return 301 /payloads.html;
    }
}
EOL

# Enable Nginx site configuration
sudo ln -sf $NGINX_CONF /etc/nginx/sites-enabled/default

# Create PPPwn service
sudo tee $PPPWN_SERVICE > /dev/null <<EOL
[Unit]
Description=PPPwn Service
After=multi-user.target

[Service]
Type=simple
ExecStart=$CURRENT_DIR/run.sh

[Install]
WantedBy=multi-user.target
EOL

sudo chmod +x /etc/systemd/system/pppwn.service
sudo systemctl enable pppwn.service

# Create PPPoE service
sudo tee $PPPOE_SERVICE > /dev/null <<EOL
[Unit]
Description=PPPoE Service
After=network.target

[Service]
Type=simple
ExecStart=$CURRENT_DIR/pppoe.sh

[Install]
WantedBy=multi-user.target
EOL

sudo chmod +x /etc/systemd/system/pppoe.service

# Set up pppoe configuration
sudo cp $CURRENT_DIR/pppoe/pppoe-server-options /etc/ppp/
sudo cp $CURRENT_DIR/pppoe/pap-secrets /etc/ppp/

echo "Installation complete."

sudo reboot
