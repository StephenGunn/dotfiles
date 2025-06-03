#!/bin/bash

# Restore script for systemd user services
# This script restores backed up systemd user services and enables them

BACKUP_DIR="$HOME/dotfiles/.config/systemd/user"
TARGET_DIR="$HOME/.config/systemd/user"

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

echo "Restoring systemd user service files..."

# Copy all service files from backup
for service_file in "$BACKUP_DIR"/*.service "$BACKUP_DIR"/*.socket "$BACKUP_DIR"/*.timer; do
    if [[ -f "$service_file" ]]; then
        cp -v "$service_file" "$TARGET_DIR/"
    fi
done

# Check if the enabled_services file exists
if [[ -f "$BACKUP_DIR/enabled_services.txt" ]]; then
    echo "Enabling systemd user services..."
    
    # Read the list of services to enable
    while read -r service; do
        if [[ ! -z "$service" ]]; then
            echo "Enabling $service..."
            systemctl --user enable "$service"
        fi
    done < "$BACKUP_DIR/enabled_services.txt"
fi

echo "Systemd user services restoration completed!"
echo "You may need to restart your session or run 'systemctl --user daemon-reload'"