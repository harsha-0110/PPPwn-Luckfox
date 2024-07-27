#!/bin/bash

# Define variables
CURRENT_DIR=$(pwd)
WEB_DIR="/var/www/pppwn"
NGINX_CONF="/etc/nginx/sites-available/default"
PPPWN_SERVICE="/etc/systemd/system/pppwn.service"
CONFIG_DIR="/etc/pppwn"
CONFIG_FILE="$CONFIG_DIR/config.json"

# Change permissions of the following files
sudo chmod +x ./update.sh
sudo chmod +x ./pppwn
sudo chmod +x ./pppoe.sh

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y nginx php-fpm php-mysql jq pppoe pppoeconf

# Create configuration directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
    sudo mkdir -p $CONFIG_DIR
fi

# Create the config.json file with the install directory if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    sudo tee $CONFIG_FILE > /dev/null <<EOL
{
    "FW_VERSION": "1100",
    "TIMEOUT": "10",
    "WAIT_AFTER_PIN": "1",
    "GROOM_DELAY": "4",
    "BUFFER_SIZE": "0",
    "AUTO_RETRY": true,
    "NO_WAIT_PADI": false,
    "REAL_SLEEP": false,
    "GOLDHEN_MOUNT": false,
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
sudo cp $CURRENT_DIR/web/* $WEB_DIR/

#Give password less suod access to www-data user
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

# Start and test Nginx
# sudo systemctl start nginx
# sudo nginx -t && sudo systemctl reload nginx

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
#sudo systemctl start pppwn.service

# Set up pppoe configuration
sudo cp $CURRENT_DIR/pppoe/pppoe.conf /etc/ppp/peers/
sudo cp $CURRENT_DIR/pppoe/pppoe-server-options /etc/ppp/
sudo cp $CURRENT_DIR/pppoe/pap-secrets /etc/ppp/
sudo cp $CURRENT_DIR/pppoe/ipaddress_pool /etc/ppp/

# Start the PPPoE server with the correct network interface
sudo bash ./pppoe.sh

echo "Installation complete."
