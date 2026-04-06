#!/bin/bash
# Daemon that manages streaming sidebar positioning:
# - Repositions sidebar after workspace switches (slide animation displaces pinned windows)
# - Hides sidebar on workspaces 4-5 (VM / scrolling layout)
# - Hides sidebar when scratchpads open
# Run this alongside streaming mode

STREAMING_STATE="/tmp/streaming-mode-active"
HIDDEN_STATE="/tmp/streaming-cams-hidden"
WS_HIDDEN="/tmp/streaming-ws-hidden"

# Sidebar positions (must match windowrules.conf)
SIDEBAR_X=2110
FACE_Y=68
TOPDOWN_Y=332
WIDGET_Y=594
OFFSCREEN_X=5000

# Check if streaming mode is active
is_streaming() {
    [[ -f "$STREAMING_STATE" ]]
}

# Get streaming windows as "title\taddress" pairs
get_streaming_windows() {
    hyprctl clients -j | jq -r '
        .[] | select(.title == "webcam-face" or .title == "webcam-topdown" or (.title | startswith("streaming-"))) |
        "\(.title)\t\(.address)"
    '
}

# Move all streaming windows to their correct sidebar positions
# Uses "exact X Y,address:ADDR" syntax (quotes required)
reposition_sidebar() {
    ~/dotfiles/scripts/webcam-expand.sh collapse-all 2>/dev/null

    local batch=""
    while IFS=$'\t' read -r title addr; do
        [[ -z "$addr" ]] && continue
        case "$title" in
            webcam-face)    batch+="dispatch movewindowpixel exact $SIDEBAR_X $FACE_Y,address:$addr; " ;;
            webcam-topdown) batch+="dispatch movewindowpixel exact $SIDEBAR_X $TOPDOWN_Y,address:$addr; " ;;
            streaming-*)    batch+="dispatch movewindowpixel exact $SIDEBAR_X $WIDGET_Y,address:$addr; " ;;
        esac
    done <<< "$(get_streaming_windows)"

    [[ -n "$batch" ]] && hyprctl --batch "$batch"
}

# Move all streaming windows off-screen
hide_sidebar() {
    local batch=""
    while IFS=$'\t' read -r title addr; do
        [[ -z "$addr" ]] && continue
        case "$title" in
            webcam-face)    batch+="dispatch movewindowpixel exact $OFFSCREEN_X $FACE_Y,address:$addr; " ;;
            webcam-topdown) batch+="dispatch movewindowpixel exact $OFFSCREEN_X $TOPDOWN_Y,address:$addr; " ;;
            streaming-*)    batch+="dispatch movewindowpixel exact $OFFSCREEN_X $WIDGET_Y,address:$addr; " ;;
        esac
    done <<< "$(get_streaming_windows)"

    [[ -n "$batch" ]] && hyprctl --batch "$batch"
}

# Check if any special workspace is visible
special_workspace_open() {
    hyprctl monitors -j | jq -e '.[].specialWorkspace.name | select(. != "")' >/dev/null 2>&1
}

# Should sidebar be hidden?
should_hide() {
    [[ -f "$WS_HIDDEN" ]] || special_workspace_open
}

# Handle any event that could change sidebar visibility/position
update_sidebar() {
    if ! is_streaming; then
        return
    fi

    if should_hide; then
        hide_sidebar
        touch "$HIDDEN_STATE"
    else
        # Always reposition — slide animation displaces pinned windows
        reposition_sidebar
        rm -f "$HIDDEN_STATE"
    fi
}

# Main loop - listen for Hyprland events
main() {
    echo "Starting streaming sidebar daemon..."

    # Clean state on start
    rm -f "$HIDDEN_STATE" "$WS_HIDDEN"

    socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
        case "$line" in
            workspace\>\>[45])
                touch "$WS_HIDDEN"
                update_sidebar
                ;;
            workspace\>\>[1-3])
                rm -f "$WS_HIDDEN"
                update_sidebar
                ;;
            activespecial*)
                update_sidebar
                ;;
        esac
    done
}

case "${1:-start}" in
    start)
        main
        ;;
    hide)
        hide_sidebar
        ;;
    show)
        reposition_sidebar
        ;;
    *)
        echo "Usage: streaming-scratchpad-daemon.sh [start|hide|show]"
        exit 1
        ;;
esac
