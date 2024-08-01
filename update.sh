#!/bin/bash

# Function to check internet connectivity
check_internet() {
    echo "Checking internet connection..."
    if ping -c 1 google.com &> /dev/null; then
        echo "Internet connection is available."
        return 0
    else
        echo "No internet connection. Please check your connection and try again."
        return 1
    fi
}

# Check internet connection
if check_internet; then
    # Pull the latest changes
    echo "Updating repository..."
    sudo git reset --hard
    sudo git pull origin main

    # Run install.sh to reapply configurations
    echo "Running install.sh..."
    sudo chmod +x ./install.sh
    sudo bash ./install.sh
else
    echo "Update aborted due to lack of internet connection."
fi
