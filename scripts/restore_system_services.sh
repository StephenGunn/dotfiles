#!/bin/bash

# Restore system-level services that need to be enabled after fresh install
# These require sudo - run manually or the install script will prompt

echo "Enabling system services..."

SERVICES=(
    bluetooth.service
    cups.service
    docker.service
    grub-btrfsd.service
    libvirtd.service
    NetworkManager.service
    sddm.service
    tailscaled.service
)

for service in "${SERVICES[@]}"; do
    echo "  → Enabling $service..."
    sudo systemctl enable "$service" 2>/dev/null || echo "    ⚠ Failed (package may not be installed yet)"
done

echo ""
echo "Done! You may need to reboot for all services to start."
