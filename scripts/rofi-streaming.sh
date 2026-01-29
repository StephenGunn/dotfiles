#!/bin/bash
# Rofi menu for streaming controls
# Provides access to streaming mode, camera controls, and settings

CONFIG="$HOME/.config/streaming/config.sh"
[[ -f "$CONFIG" ]] && source "$CONFIG"

STATE_FILE="/tmp/streaming-mode-active"
SCRIPTS="$HOME/dotfiles/scripts"

# Check streaming mode status
if [[ -f "$STATE_FILE" ]]; then
    STREAM_STATUS="ON"
    STREAM_ICON="󰄀"
    STREAM_ACTION="off"
else
    STREAM_STATUS="OFF"
    STREAM_ICON="󰄀"
    STREAM_ACTION="on"
fi

# Main menu
main_menu() {
    local options="$STREAM_ICON Toggle Streaming Mode [$STREAM_STATUS]
󰕧 Screenkey Toggle
───────────────────
󰄀 Face Camera
󰄁 Top-down Camera
───────────────────
󱂔 Camera Presets
󰃟 Image Settings
󰒓 Edit Config
───────────────────
 Swap Cameras"

    echo "$options" | rofi -dmenu -i -p "Streaming" -theme-str 'window {width: 350px;}'
}

# Camera selection submenu
camera_menu() {
    local cam_name="$1"
    local cam_device="$2"

    local options="󰯈 Reset / Center
󰍉 Zoom In
󰍉 Zoom Out
󰍉 Medium Zoom
───────────────
 Face Position
 Keyboard View
󰌌 Desk Overview
───────────────
 Pan Left
 Pan Right
 Tilt Up
 Tilt Down
───────────────
 Back to Main"

    local choice=$(echo "$options" | rofi -dmenu -i -p "$cam_name" -theme-str 'window {width: 300px;}')

    case "$choice" in
        *"Reset"*|*"Center"*) "$SCRIPTS/camera-control.sh" "$cam_device" reset ;;
        *"Zoom In"*) "$SCRIPTS/camera-control.sh" "$cam_device" zoom-in ;;
        *"Zoom Out"*) "$SCRIPTS/camera-control.sh" "$cam_device" zoom-out ;;
        *"Medium Zoom"*) "$SCRIPTS/camera-control.sh" "$cam_device" zoom-medium ;;
        *"Face Position"*) "$SCRIPTS/camera-control.sh" "$cam_device" face ;;
        *"Keyboard"*) "$SCRIPTS/camera-control.sh" "$cam_device" keyboard ;;
        *"Desk"*) "$SCRIPTS/camera-control.sh" "$cam_device" desk ;;
        *"Pan Left"*) "$SCRIPTS/camera-control.sh" "$cam_device" pan-left ;;
        *"Pan Right"*) "$SCRIPTS/camera-control.sh" "$cam_device" pan-right ;;
        *"Tilt Up"*) "$SCRIPTS/camera-control.sh" "$cam_device" tilt-up ;;
        *"Tilt Down"*) "$SCRIPTS/camera-control.sh" "$cam_device" tilt-down ;;
        *"Back"*) exec "$0" ;;  # Restart main menu
    esac
}

# Presets submenu (applies to both cameras)
presets_menu() {
    local options="󰯈 Reset All Cameras
 Both: Face Position
󰌌 Both: Desk Setup
 Standard Stream Layout
───────────────
 Back to Main"

    local choice=$(echo "$options" | rofi -dmenu -i -p "Presets" -theme-str 'window {width: 300px;}')

    case "$choice" in
        *"Reset All"*)
            "$SCRIPTS/camera-control.sh" "$CAM_FACE" reset
            "$SCRIPTS/camera-control.sh" "$CAM_TOPDOWN" reset
            ;;
        *"Both: Face"*)
            "$SCRIPTS/camera-control.sh" "$CAM_FACE" face
            "$SCRIPTS/camera-control.sh" "$CAM_TOPDOWN" face
            ;;
        *"Both: Desk"*)
            "$SCRIPTS/camera-control.sh" "$CAM_FACE" desk
            "$SCRIPTS/camera-control.sh" "$CAM_TOPDOWN" desk
            ;;
        *"Standard Stream"*)
            # Face cam: face position with slight zoom
            "$SCRIPTS/camera-control.sh" "$CAM_FACE" face
            # Top-down: keyboard view
            "$SCRIPTS/camera-control.sh" "$CAM_TOPDOWN" keyboard
            notify-send "Streaming" "Standard layout applied"
            ;;
        *"Back"*) exec "$0" ;;
    esac
}

# Image settings submenu
image_menu() {
    local options="󰃟 Bright Preset (Both)
󰃟 Natural Preset (Both)
───────────────
󰃠 Face: Bright
󰃡 Face: Natural
󰃠 Topdown: Bright
󰃡 Topdown: Natural
───────────────
 Back to Main"

    local choice=$(echo "$options" | rofi -dmenu -i -p "Image" -theme-str 'window {width: 300px;}')

    case "$choice" in
        "󰃟 Bright Preset (Both)")
            "$SCRIPTS/camera-control.sh" "$CAM_FACE" bright
            "$SCRIPTS/camera-control.sh" "$CAM_TOPDOWN" bright
            ;;
        "󰃟 Natural Preset (Both)")
            "$SCRIPTS/camera-control.sh" "$CAM_FACE" natural
            "$SCRIPTS/camera-control.sh" "$CAM_TOPDOWN" natural
            ;;
        *"Face: Bright"*) "$SCRIPTS/camera-control.sh" "$CAM_FACE" bright ;;
        *"Face: Natural"*) "$SCRIPTS/camera-control.sh" "$CAM_FACE" natural ;;
        *"Topdown: Bright"*) "$SCRIPTS/camera-control.sh" "$CAM_TOPDOWN" bright ;;
        *"Topdown: Natural"*) "$SCRIPTS/camera-control.sh" "$CAM_TOPDOWN" natural ;;
        *"Back"*) exec "$0" ;;
    esac
}

# Swap camera assignments in config
swap_cameras() {
    local temp="$CAM_FACE"
    sed -i "s|^CAM_FACE=.*|CAM_FACE=\"$CAM_TOPDOWN\"|" "$CONFIG"
    sed -i "s|^CAM_TOPDOWN=.*|CAM_TOPDOWN=\"$temp\"|" "$CONFIG"
    notify-send "Streaming" "Cameras swapped. Restart streaming mode to apply."
}

# Toggle screenkey
toggle_screenkey() {
    if pgrep -x screenkey > /dev/null; then
        pkill screenkey
        notify-send "Screenkey" "Disabled" -t 1500
    else
        source "$CONFIG"  # Reload for positions
        screenkey --position fixed \
                  --geometry "${WEBCAM_WIDTH}x${KEYS_HEIGHT}+${SIDEBAR_X}+${KEYS_Y}" \
                  --font-size medium \
                  --timeout 3 \
                  --no-systray &
        notify-send "Screenkey" "Enabled" -t 1500
    fi
}

# Main logic
choice=$(main_menu)

case "$choice" in
    *"Toggle Streaming"*)
        "$SCRIPTS/streaming-mode.sh" "$STREAM_ACTION"
        ;;
    *"Screenkey"*)
        toggle_screenkey
        ;;
    *"Face Camera"*)
        camera_menu "Face Cam" "$CAM_FACE"
        ;;
    *"Top-down Camera"*)
        camera_menu "Top-down" "$CAM_TOPDOWN"
        ;;
    *"Camera Presets"*)
        presets_menu
        ;;
    *"Image Settings"*)
        image_menu
        ;;
    *"Edit Config"*)
        # Open config in default editor via terminal
        ghostty -e "${EDITOR:-nvim}" "$CONFIG"
        ;;
    *"Swap Cameras"*)
        swap_cameras
        ;;
esac
