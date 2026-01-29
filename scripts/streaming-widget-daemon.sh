#!/bin/bash
# Simple daemon that swaps streaming widget based on active workspace
# This is a proof-of-concept - hardcoded mappings for now

# Hardcoded workspace -> widget mapping
# Available: bonsai, cmatrix, cava, pipes, none
get_widget_for_workspace() {
    case "$1" in
        1) echo "bonsai" ;;
        2) echo "cava" ;;
        3) echo "cmatrix" ;;
        4) echo "pipes" ;;
        5) echo "bonsai" ;;
        *) echo "bonsai" ;;
    esac
}

# Track current widget to avoid unnecessary swaps
CURRENT_WIDGET=""

swap_widget() {
    local workspace="$1"
    local new_widget=$(get_widget_for_workspace "$workspace")

    # Only swap if different
    if [[ "$new_widget" != "$CURRENT_WIDGET" ]]; then
        ~/dotfiles/scripts/streaming-mode.sh widget "$new_widget"
        CURRENT_WIDGET="$new_widget"
        echo "Workspace $workspace -> $new_widget"
    fi
}

# Get initial workspace
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')
swap_widget "$CURRENT_WS"

# Listen to Hyprland socket for workspace changes
SOCKET="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
echo "Listening on: $SOCKET"

socat -U - UNIX-CONNECT:"$SOCKET" | while read -r line; do
    # Debug: show all events
    echo "Event: $line"

    if [[ "$line" == workspace\>\>* ]]; then
        workspace_id="${line#workspace>>}"
        swap_widget "$workspace_id"
    fi
done
