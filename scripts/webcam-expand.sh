#!/bin/bash
# Toggle webcam between sidebar size and expanded (centered) view
# Animations are handled automatically by Hyprland

STATE_DIR="/tmp/streaming"
mkdir -p "$STATE_DIR"

# Monitor dimensions (from streaming config)
MONITOR_WIDTH=2560
MONITOR_HEIGHT=1440
PANEL_HEIGHT=47

# Small size (sidebar)
SMALL_WIDTH=430
SMALL_HEIGHT=242
SMALL_X=2110

# Small Y positions
FACE_SMALL_Y=68
TOPDOWN_SMALL_Y=332

# Large size (75% width, 16:9 aspect ratio)
LARGE_WIDTH=1920
LARGE_HEIGHT=1080

# Centered position for large size
LARGE_X=$(( (MONITOR_WIDTH - LARGE_WIDTH) / 2 ))
LARGE_Y=$(( (MONITOR_HEIGHT - LARGE_HEIGHT + PANEL_HEIGHT) / 2 ))

get_window_address() {
    local title="$1"
    hyprctl clients -j | jq -r ".[] | select(.title == \"$title\") | .address"
}

# Temporarily slow down window move animation for cinematic webcam transitions
slow_animation() {
    hyprctl keyword animation "windowsMove, 1, 10, softBounce"
}

# Restore fast animation for normal window moves
fast_animation() {
    hyprctl keyword animation "windowsMove, 1, 3, softBounce"
}

expand_webcam() {
    local title="$1"
    local state_file="$STATE_DIR/${title}-expanded"
    local addr=$(get_window_address "$title")

    if [[ -z "$addr" ]]; then
        echo "Window not found: $title"
        return 1
    fi

    # Slow animation for dramatic expand
    slow_animation

    # Move and resize to large centered position
    hyprctl --batch "dispatch movewindowpixel exact $LARGE_X $LARGE_Y,address:$addr; dispatch resizewindowpixel exact $LARGE_WIDTH $LARGE_HEIGHT,address:$addr"
    touch "$state_file"

    # Restore fast animation after transition completes
    (sleep 1.1 && fast_animation) &

    notify-send "Webcam" "${title#webcam-} expanded" -t 1000
}

collapse_webcam() {
    local title="$1"
    local small_y="$2"
    local state_file="$STATE_DIR/${title}-expanded"
    local addr=$(get_window_address "$title")

    if [[ -z "$addr" ]]; then
        echo "Window not found: $title"
        return 1
    fi

    # Slow animation for dramatic collapse
    slow_animation

    # Move and resize back to sidebar position
    hyprctl --batch "dispatch movewindowpixel exact $SMALL_X $small_y,address:$addr; dispatch resizewindowpixel exact $SMALL_WIDTH $SMALL_HEIGHT,address:$addr"
    rm -f "$state_file"

    # Restore fast animation after transition completes
    (sleep 1.1 && fast_animation) &

    notify-send "Webcam" "${title#webcam-} collapsed" -t 1000
}

toggle_webcam() {
    local title="$1"
    local small_y="$2"
    local state_file="$STATE_DIR/${title}-expanded"

    if [[ -f "$state_file" ]]; then
        collapse_webcam "$title" "$small_y"
    else
        expand_webcam "$title"
    fi
}

is_expanded() {
    local title="$1"
    [[ -f "$STATE_DIR/${title}-expanded" ]]
}

# Collapse all expanded webcams (used when scratchpad opens)
collapse_all() {
    if is_expanded "webcam-face"; then
        collapse_webcam "webcam-face" "$FACE_SMALL_Y"
    fi
    if is_expanded "webcam-topdown"; then
        collapse_webcam "webcam-topdown" "$TOPDOWN_SMALL_Y"
    fi
}

case "${1:-}" in
    face)
        toggle_webcam "webcam-face" "$FACE_SMALL_Y"
        ;;
    topdown|keyboard|hands)
        toggle_webcam "webcam-topdown" "$TOPDOWN_SMALL_Y"
        ;;
    expand-face)
        expand_webcam "webcam-face"
        ;;
    expand-topdown)
        expand_webcam "webcam-topdown"
        ;;
    collapse-face)
        collapse_webcam "webcam-face" "$FACE_SMALL_Y"
        ;;
    collapse-topdown)
        collapse_webcam "webcam-topdown" "$TOPDOWN_SMALL_Y"
        ;;
    collapse-all)
        collapse_all
        ;;
    status)
        echo "Face: $(is_expanded webcam-face && echo 'expanded' || echo 'sidebar')"
        echo "Topdown: $(is_expanded webcam-topdown && echo 'expanded' || echo 'sidebar')"
        ;;
    *)
        echo "Usage: webcam-expand.sh <face|topdown|keyboard|collapse-all|status>"
        echo ""
        echo "Commands:"
        echo "  face              Toggle face webcam size"
        echo "  topdown/keyboard  Toggle top-down webcam size"
        echo "  collapse-all      Collapse all expanded webcams"
        echo "  status            Show current state"
        exit 1
        ;;
esac
