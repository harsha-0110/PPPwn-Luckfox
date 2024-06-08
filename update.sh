#!/bin/bash

# Variables
INSTALL_DIR="/opt/PPPwn-Luckfox"
SERVICE_NAME="pppwn"
NGINX_SERVICE="nginx"

# Stop the services
echo "Stopping services..."
sudo systemctl stop $SERVICE_NAME.service
sudo systemctl stop $NGINX_SERVICE

# Pull the latest changes
echo "Updating repository..."
cd $INSTALL_DIR
git pull origin main

# Run install.sh to reapply configurations
echo "Running install.sh..."
sudo bash $INSTALL_DIR/install.sh

# Restart the services
echo "Restarting services..."
sudo systemctl restart $SERVICE_NAME.service
sudo systemctl restart $NGINX_SERVICE

echo "Update complete and services restarted."
