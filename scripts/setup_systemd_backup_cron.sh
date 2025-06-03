#!/bin/bash

# Script to setup a cron job for regular systemd service backups
# This will add a weekly cron job to backup your systemd services

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_SCRIPT="$SCRIPT_DIR/backup_systemd_services.sh"

# Make sure the backup script exists and is executable
if [ ! -f "$BACKUP_SCRIPT" ]; then
    echo "Error: Backup script not found at $BACKUP_SCRIPT"
    exit 1
fi

chmod +x "$BACKUP_SCRIPT"

# Check if cron is installed
if ! command -v crontab &> /dev/null; then
    echo "Error: crontab command not found. Please install cron first."
    echo "On Arch Linux: sudo pacman -S cronie"
    exit 1
fi

# Create a temporary file with current crontab
crontab -l > /tmp/current_cron 2>/dev/null || echo "" > /tmp/current_cron

# Check if the cron job already exists
if grep -q "$BACKUP_SCRIPT" /tmp/current_cron; then
    echo "Cron job for systemd backup already exists."
else
    # Add the new cron job - runs every Sunday at 12:00 PM (noon)
    echo "# Backup systemd services every Sunday at noon" >> /tmp/current_cron
    echo "0 12 * * 0 $BACKUP_SCRIPT > $HOME/.systemd_backup.log 2>&1" >> /tmp/current_cron
    
    # Install the new crontab
    crontab /tmp/current_cron
    echo "Cron job for weekly systemd backup added successfully!"
    echo "It will run every Sunday at 12:00 PM (noon)"
fi

# Clean up
rm /tmp/current_cron

echo "To check your crontab, run: crontab -l"
echo "To edit your crontab, run: crontab -e"