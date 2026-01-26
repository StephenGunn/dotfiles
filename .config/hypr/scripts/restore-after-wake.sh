#!/bin/bash
# Restore Hyprland configuration after waking from suspend
# This script ensures monitors, workspaces, and panels are properly restored

# Log start time
echo "$(date): Starting wake restoration" >> /tmp/hyprland-wake.log

# Force DisplayPort re-detection for AMD GPUs
# This helps with DPCD communication failures after suspend
echo "$(date): Forcing DP re-detection" >> /tmp/hyprland-wake.log
for dp in /sys/class/drm/card*/card*/status; do
    if [ -f "$dp" ]; then
        echo detect > "$dp" 2>/dev/null || true
    fi
done

# Small delay for DP to stabilize
sleep 1

# Re-enable displays
echo "$(date): Enabling DPMS" >> /tmp/hyprland-wake.log
hyprctl dispatch dpms on

# Give monitors time to sync after DPMS on
sleep 1

# Force monitor reconfiguration
echo "$(date): Reloading Hyprland config" >> /tmp/hyprland-wake.log
hyprctl reload

# Small delay after reload
sleep 0.5

# Reassign workspaces to correct monitors
# Main monitor (DP-2) - workspaces 1-5
hyprctl dispatch moveworkspacetomonitor 1 DP-2
hyprctl dispatch moveworkspacetomonitor 2 DP-2
hyprctl dispatch moveworkspacetomonitor 3 DP-2
hyprctl dispatch moveworkspacetomonitor 4 DP-2
hyprctl dispatch moveworkspacetomonitor 5 DP-2

# Vertical monitor (DP-3) - workspaces 6-10
hyprctl dispatch moveworkspacetomonitor 6 DP-3
hyprctl dispatch moveworkspacetomonitor 7 DP-3
hyprctl dispatch moveworkspacetomonitor 8 DP-3
hyprctl dispatch moveworkspacetomonitor 9 DP-3
hyprctl dispatch moveworkspacetomonitor 10 DP-3

# Restart HyprPanel to ensure it's on the correct monitor
# Kill existing panel gracefully
pkill -x hyprpanel

# Small delay before restarting
sleep 0.3

# Restart HyprPanel
hyprpanel &

# Log completion
echo "$(date): Hyprland wake-up restoration complete" >> /tmp/hyprland-wake.log
