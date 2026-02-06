#!/bin/bash
# Control OBS privacy blur overlay for sensitive content
# Used by Neovim autocmds to blur window when .env files are open

STATE_FILE="/tmp/streaming-blur-active"
CONFIG="$HOME/.config/streaming/config.sh"
DAEMON="$HOME/projects/privacy-daemon/privacy-daemon"

# Load config
[[ -f "$CONFIG" ]] && source "$CONFIG"

# Check dependencies
check_deps() {
    if ! daemon_running; then
        echo "Error: privacy-daemon not running"
        echo "Start with: systemctl --user start privacy-daemon"
        exit 1
    fi
}

daemon_running() {
    [[ -S "/tmp/privacy-daemon.sock" ]]
}

# Get the focused window info (address, position, size)
get_window_info() {
    hyprctl activewindow -j 2>/dev/null
}

# Get window info by title pattern
get_window_by_title() {
    local title_pattern="$1"
    hyprctl clients -j 2>/dev/null | \
        jq -r --arg pat "$title_pattern" '[.[] | select(.title | test($pat))] | .[0] // empty'
}

# Extract geometry from window info
parse_window_geometry() {
    local window_info="$1"

    if [[ -z "$window_info" || "$window_info" == "null" ]]; then
        echo "unknown 0 0 800 600"
        return 1
    fi

    local addr=$(echo "$window_info" | jq -r '.address // "unknown"')
    local x=$(echo "$window_info" | jq -r '.at[0] // 0')
    local y=$(echo "$window_info" | jq -r '.at[1] // 0')
    local w=$(echo "$window_info" | jq -r '.size[0] // 800')
    local h=$(echo "$window_info" | jq -r '.size[1] // 600')

    echo "$addr $x $y $w $h"
}

# Show the blur overlay positioned over the terminal window
blur_on() {
    check_deps

    # Get window info
    local window_info=$(get_window_info)
    read -r addr x y w h <<< "$(parse_window_geometry "$window_info")"

    if [[ "$addr" == "unknown" ]]; then
        echo "Error: Could not find active window"
        exit 1
    fi

    # Scale from desktop (1440p) to OBS canvas (1080p)
    local canvas_w=${OBS_CANVAS_WIDTH:-1920}
    local canvas_h=${OBS_CANVAS_HEIGHT:-1080}
    local monitor_w=${MONITOR_WIDTH:-2560}
    local monitor_h=${MONITOR_HEIGHT:-1440}

    # Scale coordinates
    local obs_x=$(awk "BEGIN {printf \"%.0f\", $x * $canvas_w / $monitor_w}")
    local obs_y=$(awk "BEGIN {printf \"%.0f\", $y * $canvas_h / $monitor_h}")
    local obs_w=$(awk "BEGIN {printf \"%.0f\", $w * $canvas_w / $monitor_w}")
    local obs_h=$(awk "BEGIN {printf \"%.0f\", $h * $canvas_h / $monitor_h}")

    "$DAEMON" blur "$addr" "$obs_x" "$obs_y" "$obs_w" "$obs_h"

    # Also blur hand cam window if it exists
    blur_window_by_title "webcam-topdown" "handcam"

    touch "$STATE_FILE"
    echo "Blur ON: $addr (${obs_w}x${obs_h} at ${obs_x},${obs_y})"
}

# Blur a window found by title pattern
blur_window_by_title() {
    local title_pattern="$1"
    local blur_id="$2"

    local window_info=$(get_window_by_title "$title_pattern")
    if [[ -z "$window_info" || "$window_info" == "null" ]]; then
        return 1
    fi

    read -r addr x y w h <<< "$(parse_window_geometry "$window_info")"

    # Scale coordinates
    local canvas_w=${OBS_CANVAS_WIDTH:-1920}
    local canvas_h=${OBS_CANVAS_HEIGHT:-1080}
    local monitor_w=${MONITOR_WIDTH:-2560}
    local monitor_h=${MONITOR_HEIGHT:-1440}

    local obs_x=$(awk "BEGIN {printf \"%.0f\", $x * $canvas_w / $monitor_w}")
    local obs_y=$(awk "BEGIN {printf \"%.0f\", $y * $canvas_h / $monitor_h}")
    local obs_w=$(awk "BEGIN {printf \"%.0f\", $w * $canvas_w / $monitor_w}")
    local obs_h=$(awk "BEGIN {printf \"%.0f\", $h * $canvas_h / $monitor_h}")

    "$DAEMON" blur "$blur_id" "$obs_x" "$obs_y" "$obs_w" "$obs_h"
    echo "Blur ON: $blur_id ($title_pattern)"
}

# Hide the blur overlay for current window
blur_off() {
    check_deps

    # Get window info to find the ID
    local window_info=$(get_window_info)
    local addr=$(echo "$window_info" | jq -r '.address // "unknown"' 2>/dev/null)

    if [[ "$addr" != "unknown" && -n "$addr" ]]; then
        "$DAEMON" unblur "$addr"
    fi

    # Also unblur hand cam
    "$DAEMON" unblur "handcam"

    rm -f "$STATE_FILE"
    echo "Blur OFF: $addr"
}

# Toggle blur state
blur_toggle() {
    if [[ -f "$STATE_FILE" ]]; then
        blur_off
    else
        blur_on
    fi
}

# Show status
blur_status() {
    if [[ -f "$STATE_FILE" ]]; then
        echo "Content blur: ON"
        exit 0
    else
        echo "Content blur: OFF"
        exit 1
    fi
}

# Clear all blur filters
blur_clear() {
    check_deps
    "$DAEMON" clear
    rm -f "$STATE_FILE"
    echo "All blurs cleared"
}

# List active blur assignments
blur_list() {
    check_deps
    "$DAEMON" list
}

# Handle arguments
case "${1:-status}" in
    on)
        blur_on
        ;;
    off)
        blur_off
        ;;
    toggle)
        blur_toggle
        ;;
    clear)
        blur_clear
        ;;
    list)
        blur_list
        ;;
    status)
        blur_status
        ;;
    *)
        echo "Usage: streaming-blur.sh [on|off|toggle|clear|list|status]"
        echo ""
        echo "Controls OBS privacy blur for sensitive content."
        echo "Uses custom shader filter with region-based pixelation."
        echo ""
        echo "Commands:"
        echo "  on      - Blur current window"
        echo "  off     - Unblur current window"
        echo "  toggle  - Toggle blur on current window"
        echo "  clear   - Remove all blurs"
        echo "  list    - Show active blur assignments"
        echo "  status  - Show if any blurs are active"
        exit 1
        ;;
esac
