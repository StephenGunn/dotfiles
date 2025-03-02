#!/bin/bash

# Get current zoom factor
current=$(hyprctl getoption cursor:zoom_factor | grep "Float:" | awk '{print $2}')

# For debugging
echo "Current zoom factor: $current" >> /tmp/cursor-zoom-debug.log

# Compare with precision
if (( $(echo "$current > 1.1" | bc -l) )); then
    # If currently zoomed, set back to 1.0
    hyprctl keyword cursor:zoom_factor 1.0
    notify-send "Cursor zoom disabled"
    echo "Zoom disabled, set to 1.0" >> /tmp/cursor-zoom-debug.log
else
    # If not zoomed, set to 2.0
    hyprctl keyword cursor:zoom_factor 2.0
    notify-send "Cursor zoom enabled (2x)"
    echo "Zoom enabled, set to 2.0" >> /tmp/cursor-zoom-debug.log
fi
