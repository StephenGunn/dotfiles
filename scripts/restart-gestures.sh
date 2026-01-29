#!/usr/bin/env bash
# Restart libinput-gestures service
# Use this when trackpad gestures stop working

echo "Restarting libinput-gestures service..."
systemctl --user restart libinput-gestures

if [ $? -eq 0 ]; then
    echo "✓ Gestures service restarted successfully"
    notify-send "Gestures Restarted" "Trackpad gestures should now be working" -i input-touchpad
else
    echo "✗ Failed to restart gestures service"
    notify-send "Gestures Restart Failed" "Check systemctl status" -u critical -i dialog-error
    exit 1
fi
