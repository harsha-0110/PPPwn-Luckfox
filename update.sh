#!/bin/bash

# Function to check internet connection
check_internet_connection() {
    echo "Checking internet connection..."
    ping -c 1 google.com &> /dev/null

    if [ $? -eq 0 ]; then
        echo "Internet connection is available."
        return 0
    else
        echo "No internet connection."
        return 1
    fi
}

# Function to check for updates in the Git repository
check_git_updates() {
    echo "Checking for updates in the repository..."

    # Fetch the latest changes from the remote
    sudo git fetch origin main

    # Compare the local branch with the remote branch
    LOCAL=$(sudo git rev-parse HEAD)
    REMOTE=$(sudo git rev-parse origin/main)

    if [ "$LOCAL" != "$REMOTE" ]; then
        echo "Updates found in the repository."
        return 0
    else
        echo "No updates found in the repository."
        return 1
    fi
}

# Main script
if check_internet_connection && check_git_updates; then
    # Pull the latest changes
    echo "Updating repository..."
    sudo git reset --hard
    sudo git pull origin main

    # Run install.sh to reapply configurations
    echo "Running install.sh..."
    sudo chmod +x ./install.sh
    sudo bash ./install.sh
else
    echo "Update process aborted."
fi

