#!/bin/bash

# Define variables
CURRENT_DIR=$(pwd)
WEB_DIR="/var/www/pppwn"
NGINX_CONF="/etc/nginx/sites-available/default"
PPPWN_SERVICE="/etc/systemd/system/pppwn.service"
CONFIG_DIR="/etc/pppwn"
CONFIG_FILE="$CONFIG_DIR/config.json"

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y nginx php-fpm php-mysql jq pppoe pppoeconf

# Create configuration directory if it doesn't exist
sudo mkdir -p $CONFIG_DIR

# Copy the default config file if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    sudo cp $CURRENT_DIR/config.json $CONFIG_FILE
fi
sudo chmod 777 $CONFIG_FILE

# Remove the web directory if it already exists
if [ -d "$WEB_DIR" ]; then
    sudo rm -rf $WEB_DIR
fi

# Set up the web directory
sudo mkdir -p $WEB_DIR
sudo cp $CURRENT_DIR/web/* $WEB_DIR/

# Detect the PHP-FPM version
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
PHP_FPM_SOCK="/var/run/php/php${PHP_VERSION}-fpm.sock"

# Set up Nginx configuration
sudo tee $NGINX_CONF > /dev/null <<EOL
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;

    root $WEB_DIR;
    index config.php index.html index.htm;

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

# Start and test Nginx
sudo systemctl start nginx
sudo nginx -t && sudo systemctl reload nginx

# Set up systemd service for pppwn
sudo tee $PPPWN_SERVICE > /dev/null <<EOL
[Unit]
Description=PPPwn Service
After=network.target

[Service]
Type=simple
ExecStart=$CURRENT_DIR/run.sh

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl enable pppwn.service
sudo systemctl start pppwn.service

# Set up pppoe configuration
sudo cp $CURRENT_DIR/pppoe/pppoe.conf /etc/ppp/peers/
sudo cp $CURRENT_DIR/pppoe/pppoe-server-options /etc/ppp/
sudo cp $CURRENT_DIR/pppoe/pap-secrets /etc/ppp/
sudo cp $CURRENT_DIR/pppoe/ipaddress_pool /etc/ppp/

# Start the PPPoE server with the correct network interface
sudo bash ./pppoe.sh

echo "Installation complete. Please ensure all configurations are correct."
