#!/usr/bin/env bash
# Save screenshot to ~/Pictures/screenshots/ and copy path to clipboard

# Create screenshots directory if it doesn't exist
mkdir -p "$HOME/Pictures/screenshots"

# Generate filename with timestamp
filename="$(date +'%s_screenshot.png')"
filepath="$HOME/Pictures/screenshots/$filename"

# Take screenshot with grim and slurp
grim -g "$(slurp)" "$filepath"

# Check if screenshot was saved successfully
if [ -f "$filepath" ]; then
    # Copy the full path to clipboard
    echo -n "$filepath" | wl-copy

    # Optional: Show notification (requires notify-send)
    if command -v notify-send &> /dev/null; then
        notify-send "Screenshot saved" "$filepath"
    fi
fi
