#!/bin/bash
# Run with: sudo ./scripts/setup-gestures-sleep-hook.sh
#
# This script installs a systemd sleep hook that:
# 1. Reconnects the Magic Trackpad via Bluetooth or resets USB after wake
# 2. Restarts libinput-gestures to restore gesture support

cat > /usr/lib/systemd/system-sleep/libinput-gestures << 'EOF'
#!/bin/bash
case "$1" in
    post)
        sleep 2
        # Reconnect Magic Trackpad (Bluetooth or USB)
        /home/stephen/dotfiles/scripts/trackpad-reconnect.sh
        sleep 3
        # Restart gestures service
        /usr/bin/runuser -u stephen -- systemctl --user restart libinput-gestures
        ;;
esac
EOF

chmod +x /usr/lib/systemd/system-sleep/libinput-gestures
echo "✓ Sleep hook installed (Trackpad reconnect + gestures restart)"
