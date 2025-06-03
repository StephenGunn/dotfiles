#!/bin/bash

# Script to configure HyprPanel and set up autostart

HYPRPANEL_DIR="$HOME/.local/share/HyprPanel"
HYPR_CONFIG_DIR="$HOME/.config/hypr"
HYPR_CONFIG_FILE="$HYPR_CONFIG_DIR/hyprland.conf"

# Check if HyprPanel is installed
if [ ! -d "$HYPRPANEL_DIR" ]; then
    echo "HyprPanel is not installed. Please run install.sh first."
    exit 1
fi

# Ensure hyprland config directory exists
mkdir -p "$HYPR_CONFIG_DIR"

# Check if hyprland.conf exists
if [ ! -f "$HYPR_CONFIG_FILE" ]; then
    echo "Creating minimal hyprland.conf..."
    touch "$HYPR_CONFIG_FILE"
fi

# Add hyprpanel to autostart if not already added
if ! grep -q "exec-once = hyprpanel" "$HYPR_CONFIG_FILE"; then
    echo "Adding HyprPanel to Hyprland autostart..."
    echo -e "\n# Start HyprPanel\nexec-once = hyprpanel" >> "$HYPR_CONFIG_FILE"
    echo "HyprPanel added to autostart."
else
    echo "HyprPanel is already in Hyprland autostart."
fi

# Check if we need to create a systemd user service for HyprPanel
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
HYPRPANEL_SERVICE="$SYSTEMD_USER_DIR/hyprpanel.service"

# Create systemd user directory if it doesn't exist
mkdir -p "$SYSTEMD_USER_DIR"

# Create service file if it doesn't exist
if [ ! -f "$HYPRPANEL_SERVICE" ]; then
    echo "Creating HyprPanel systemd user service..."
    cat > "$HYPRPANEL_SERVICE" << EOF
[Unit]
Description=HyprPanel Service
PartOf=graphical-session.target
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/hyprpanel
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=default.target
EOF

    echo "Enabling HyprPanel systemd user service..."
    systemctl --user enable hyprpanel.service
    echo "HyprPanel service created and enabled."
else
    echo "HyprPanel systemd user service already exists."
fi

# Copy configuration files from dotfiles if they exist
DOTFILES_HYPRPANEL_CONFIG="$HOME/dotfiles/hyprpanel_config.json"
HYPRPANEL_CONFIG_DIR="$HOME/.config/ags"

if [ -f "$DOTFILES_HYPRPANEL_CONFIG" ]; then
    echo "Copying HyprPanel configuration from dotfiles..."
    cp "$DOTFILES_HYPRPANEL_CONFIG" "$HYPRPANEL_CONFIG_DIR/config.json"
    echo "HyprPanel configuration updated."
else
    echo "No custom HyprPanel configuration found in dotfiles."
fi

echo "HyprPanel configuration complete!"
echo "You can start HyprPanel by:"
echo "1. Restarting Hyprland (if autostart is configured)"
echo "2. Running 'hyprpanel' manually"
echo "3. Starting the systemd service: systemctl --user start hyprpanel.service"