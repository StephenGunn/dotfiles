#!/bin/bash

# Configure SDDM display manager
# Run after install with sudo

USERNAME="${1:-stephen}"

echo "Configuring SDDM..."

# Install catppuccin SDDM theme if not present
if [ ! -d /usr/share/sddm/themes/catppuccin-mocha ]; then
    echo "  → Installing Catppuccin SDDM theme..."
    if command -v yay &>/dev/null; then
        yay -S --noconfirm sddm-catppuccin-mocha 2>/dev/null || echo "  ⚠ Theme package not found, install manually"
    fi
fi

# Write SDDM config
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/kde_settings.conf > /dev/null <<EOF
[Autologin]
Relogin=false
Session=hyprland
User=$USERNAME

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot

[Theme]
Current=catppuccin-mocha

[Users]
MaximumUid=60513
MinimumUid=1000
EOF

echo "  ✓ SDDM configured (autologin as $USERNAME, catppuccin-mocha theme)"
