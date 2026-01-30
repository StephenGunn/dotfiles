#!/bin/bash
# Daemon that auto-hides streaming webcams when scratchpads open
# Run this alongside streaming mode

STREAMING_STATE="/tmp/streaming-mode-active"
HIDDEN_STATE="/tmp/streaming-cams-hidden"

# Check if streaming mode is active
is_streaming() {
    [[ -f "$STREAMING_STATE" ]]
}

# Hide webcam windows (move off-screen)
hide_cams() {
    if [[ -f "$HIDDEN_STATE" ]]; then
        return  # Already hidden
    fi

    # Get window addresses
    local face_addr=$(hyprctl clients -j | jq -r '.[] | select(.title == "webcam-face") | .address')
    local topdown_addr=$(hyprctl clients -j | jq -r '.[] | select(.title == "webcam-topdown") | .address')

    # Move off-screen (to the right)
    [[ -n "$face_addr" ]] && hyprctl dispatch movewindowpixel exact 3000 68,address:$face_addr
    [[ -n "$topdown_addr" ]] && hyprctl dispatch movewindowpixel exact 3000 332,address:$topdown_addr

    touch "$HIDDEN_STATE"
}

# Show webcam windows (restore to sidebar)
show_cams() {
    if [[ ! -f "$HIDDEN_STATE" ]]; then
        return  # Not hidden
    fi

    # First collapse any expanded webcams
    ~/dotfiles/scripts/webcam-expand.sh collapse-all 2>/dev/null

    # Get window addresses
    local face_addr=$(hyprctl clients -j | jq -r '.[] | select(.title == "webcam-face") | .address')
    local topdown_addr=$(hyprctl clients -j | jq -r '.[] | select(.title == "webcam-topdown") | .address')

    # Restore to sidebar positions
    [[ -n "$face_addr" ]] && hyprctl dispatch movewindowpixel exact 2110 68,address:$face_addr
    [[ -n "$topdown_addr" ]] && hyprctl dispatch movewindowpixel exact 2110 332,address:$topdown_addr

    rm -f "$HIDDEN_STATE"
}

# Check if any special workspace is visible
special_workspace_open() {
    hyprctl monitors -j | jq -e '.[].specialWorkspace.name | select(. != "")' >/dev/null 2>&1
}

# Handle workspace changes
handle_workspace_event() {
    if ! is_streaming; then
        return
    fi

    if special_workspace_open; then
        hide_cams
    else
        show_cams
    fi
}

# Main loop - listen for Hyprland events
main() {
    echo "Starting streaming scratchpad daemon..."

    # Clean state on start
    rm -f "$HIDDEN_STATE"

    socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
        case "$line" in
            activespecial*)
                handle_workspace_event
                ;;
        esac
    done
}

case "${1:-start}" in
    start)
        main
        ;;
    hide)
        hide_cams
        ;;
    show)
        show_cams
        ;;
    *)
        echo "Usage: streaming-scratchpad-daemon.sh [start|hide|show]"
        exit 1
        ;;
esac
