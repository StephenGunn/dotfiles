#!/bin/bash
# Monitor Hyprland events and restart hyprpanel when monitors change state
# This fixes workspace layouts when monitors are powered on/off

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    if echo "$line" | grep -q "monitoradded\|dpms>>1"; then
        sleep 0.5
        pkill hyprpanel
        hyprpanel &
    fi
done
