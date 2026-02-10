#!/bin/bash
# Reconnect Magic Trackpad via Bluetooth or reset USB connection
# Note: Requires sudoers entry for passwordless modprobe:
#   stephen ALL=(ALL) NOPASSWD: /usr/bin/modprobe -r hid_magicmouse, /usr/bin/modprobe hid_magicmouse

MAC="D0:C0:50:D1:6C:15"
USB_VENDOR="05ac"
USB_PRODUCT="0324"

# Try Bluetooth first
if bluetoothctl connect "$MAC" 2>/dev/null | grep -q "successful"; then
    echo "Connected via Bluetooth"
    exit 0
fi

# If Bluetooth fails, try USB module reload
if lsusb | grep -q "${USB_VENDOR}:${USB_PRODUCT}"; then
    echo "Resetting USB connection..."
    sudo modprobe -r hid_magicmouse && sudo modprobe hid_magicmouse
    echo "Reset USB connection"
    exit 0
fi

echo "No Magic Trackpad found via USB or Bluetooth"
exit 1
