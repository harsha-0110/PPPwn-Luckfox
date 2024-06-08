#!/bin/bash

# Define variables
REPO_DIR=$(pwd)
INSTALL_DIR="/opt/PPPwn-Luckfox"
WEB_DIR="/var/www/pppwn"
NGINX_CONF="/etc/nginx/sites-available/pppwn"
NGINX_CONF_LINK="/etc/nginx/sites-enabled/pppwn"
SERVICE_FILE="/etc/systemd/system/pppwn.service"

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y nginx pppoe pppoeconf git

# Copy the repository to /opt
sudo rm -rf $INSTALL_DIR
sudo cp -r $REPO_DIR $INSTALL_DIR

# Set up the web directory
sudo mkdir -p $WEB_DIR
sudo cp $INSTALL_DIR/web/* $WEB_DIR/
sudo chown -R www-data:www-data $WEB_DIR

# Set up Nginx configuration
sudo tee $NGINX_CONF > /dev/null <<EOL
server {
    listen 80;
    server_name localhost;

    root $WEB_DIR;
    index config.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /some/path {
        return 301 /payloads.html;
    }
}
EOL

# Enable Nginx site configuration
sudo ln -sf $NGINX_CONF $NGINX_CONF_LINK

# Test and restart Nginx
sudo nginx -t && sudo systemctl restart nginx

# Set up systemd service for pppwn
sudo cp $INSTALL_DIR/service/pppwn.service $SERVICE_FILE
sudo systemctl enable pppwn.service
sudo systemctl start pppwn.service

# Set up pppoe configuration
sudo cp $INSTALL_DIR/pppoe/pppoe.conf /etc/ppp/peers/
sudo cp $INSTALL_DIR/pppoe/pppoe-server-options /etc/ppp/
sudo cp $INSTALL_DIR/pppoe/pap-secrets /etc/ppp/

# Create and set up run.sh
sudo cp $INSTALL_DIR/run.sh /usr/local/bin/run.sh
sudo chmod +x /usr/local/bin/run.sh

# Run run.sh on startup
sudo tee /etc/rc.local > /dev/null <<EOL
#!/bin/sh -e
/usr/local/bin/run.sh
exit 0
EOL
sudo chmod +x /etc/rc.local

echo "Installation complete. Please ensure all configurations are correct."
