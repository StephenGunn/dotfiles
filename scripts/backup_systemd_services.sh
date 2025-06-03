#!/bin/bash

# Backup script for systemd user services
# This script backs up enabled systemd user services and units

BACKUP_DIR="$HOME/dotfiles/.config/systemd/user"
mkdir -p "$BACKUP_DIR"

echo "Backing up enabled systemd user services..."

# Get list of enabled services
ENABLED_SERVICES=$(systemctl --user list-unit-files | grep "enabled" | awk '{print $1}')

# Create a file with the list of enabled services
echo "$ENABLED_SERVICES" > "$BACKUP_DIR/enabled_services.txt"

echo "Backing up actual service files..."
for service in $ENABLED_SERVICES; do
    # Skip files that don't exist or are sockets/timers
    if [[ -f "$HOME/.config/systemd/user/$service" ]]; then
        cp -v "$HOME/.config/systemd/user/$service" "$BACKUP_DIR/"
    fi
done

echo "Systemd user services backup completed!"