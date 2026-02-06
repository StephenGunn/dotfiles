#!/bin/bash
# Toggle scratchpad and reposition if streaming mode is active
#
# WHY THIS EXISTS:
# Hyprland windowrules don't cleanly override each other when multiple rules
# match the same window. Using `center = on` in a base rule prevents later
# rules from repositioning with `move`. Rather than fighting with windowrule
# conflicts, we use hyprctl dispatch movewindowpixel to directly position
# the window when streaming mode is active.

STREAMING_STATE="/tmp/streaming-mode-active"

# Toggle the scratchpad
hyprctl dispatch togglespecialworkspace magic

# If streaming mode is on, move scratchpad to correct position
if [[ -f "$STREAMING_STATE" ]]; then
    sleep 0.1  # Brief delay for window to appear
    scratchpad_addr=$(hyprctl clients -j | jq -r '.[] | select(.workspace.name == "special:magic") | .address')
    if [[ -n "$scratchpad_addr" ]]; then
        hyprctl dispatch movewindowpixel exact 100 100,address:$scratchpad_addr
    fi
fi
