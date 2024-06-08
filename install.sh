#!/bin/bash

# Get the current directory
INSTALL_DIR=$(pwd)

# Variables
SERVICE_NAME="pppwn"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
NGINX_CONFIG_FILE="/etc/nginx/sites-available/pppwn"
NGINX_ENABLED_CONFIG="/etc/nginx/sites-enabled/pppwn"

# Ensure required directories and files exist
if [ ! -d "$INSTALL_DIR/pppoe" ] || [ ! -d "$INSTALL_DIR/web" ] || [ ! -f "$INSTALL_DIR/service/pppwn.service" ]; then
    echo "Required directories or files are missing. Make sure you have pppoe, web directories and pppwn.service file."
    exit 1
fi

# Install PPPoE configuration files
echo "Installing PPPoE configuration files..."
sudo cp "$INSTALL_DIR/pppoe/pppoe.conf" /etc/ppp/pppoe.conf
sudo cp "$INSTALL_DIR/pppoe/pppoe-server-options" /etc/ppp/pppoe-server-options
sudo cp "$INSTALL_DIR/pppoe/pap-secrets" /etc/ppp/pap-secrets

# Install systemd service
echo "Installing systemd service..."
sudo cp "$INSTALL_DIR/service/pppwn.service" $SERVICE_FILE

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the pppwn service to start on boot
sudo systemctl enable $SERVICE_NAME.service

# Set up nginx configuration
echo "Setting up nginx configuration..."
sudo bash -c "cat > $NGINX_CONFIG_FILE <<EOL
server {
    listen 0.0.0.0:80;
    server_name _;

    root $WEB_DIR;
    index config.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /some/path {
        return 301 /payloads.html;
    }
}
EOL"

# Enable nginx site configuration
sudo ln -sf $NGINX_CONFIG_FILE $NGINX_ENABLED_CONFIG

# Reload nginx to apply the new configuration
sudo systemctl reload nginx

# Start or restart the services
echo "Starting services..."
sudo systemctl restart $SERVICE_NAME.service
sudo systemctl restart nginx

echo "Installation complete."
