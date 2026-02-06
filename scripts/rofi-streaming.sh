#!/bin/bash
# Rofi menu for streaming controls
# Provides access to streaming mode, camera controls, and settings

CONFIG="$HOME/.config/streaming/config.sh"
[[ -f "$CONFIG" ]] && source "$CONFIG"

STATE_FILE="/tmp/streaming-mode-active"
PRIVACY_FACE="/tmp/streaming-privacy-face"
PRIVACY_TOPDOWN="/tmp/streaming-privacy-topdown"
PRIVACY_BLUR="/tmp/streaming-blur-active"
EXPAND_FACE="/tmp/streaming/webcam-face-expanded"
EXPAND_TOPDOWN="/tmp/streaming/webcam-topdown-expanded"
RECORDING_STATE="/tmp/screen-recording-active"
RECORDINGS_DIR="$HOME/Videos/Recordings"
SCRIPTS="$HOME/dotfiles/scripts"

# Check privacy status
[[ -f "$PRIVACY_FACE" ]] && PRIV_FACE="ON" || PRIV_FACE="OFF"
[[ -f "$PRIVACY_TOPDOWN" ]] && PRIV_HANDS="ON" || PRIV_HANDS="OFF"
[[ -f "$PRIVACY_BLUR" ]] && PRIV_BLUR="ON" || PRIV_BLUR="OFF"

# Check expand status
[[ -f "$EXPAND_FACE" ]] && EXP_FACE="ON" || EXP_FACE="OFF"
[[ -f "$EXPAND_TOPDOWN" ]] && EXP_HANDS="ON" || EXP_HANDS="OFF"

# Check recording status
[[ -f "$RECORDING_STATE" ]] && REC_STATUS="ON" || REC_STATUS="OFF"

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
󰑊 Screen Recording [$REC_STATUS]
󰗹 Privacy Mode
󰗹 Clear All Blurs
───────────────────
󰹑 Expand Face Cam [$EXP_FACE]
󰹑 Expand Keyboard Cam [$EXP_HANDS]
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

# Privacy mode submenu
privacy_menu() {
    local options="󰗹 Clear All Blurs [$PRIV_BLUR]
───────────────
󰄀 Face Cam Pixelate [$PRIV_FACE]
󰄁 Hand Cam Pixelate [$PRIV_HANDS]
󰄀 Toggle Both Cams
───────────────
 Back to Main"

    local choice=$(echo "$options" | rofi -dmenu -i -p "Privacy" -theme-str 'window {width: 300px;}')

    case "$choice" in
        *"Clear All Blurs"*) "$SCRIPTS/streaming-blur.sh" clear ;;
        *"Face Cam"*) "$SCRIPTS/streaming-mode.sh" privacy face ;;
        *"Hand Cam"*) "$SCRIPTS/streaming-mode.sh" privacy hands ;;
        *"Toggle Both"*) "$SCRIPTS/streaming-mode.sh" privacy both ;;
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

# Toggle screen recording
toggle_recording() {
    if [[ -f "$RECORDING_STATE" ]]; then
        # Stop recording - SIGINT lets gpu-screen-recorder finalize the file
        pkill -SIGINT -f "gpu-screen-recorder.*$RECORDINGS_DIR"
        sleep 0.5  # Give it a moment to finalize
        rm -f "$RECORDING_STATE"
        notify-send "Screen Recording" "Stopped - saved to $RECORDINGS_DIR" -t 3000
    else
        mkdir -p "$RECORDINGS_DIR"
        local filename="$RECORDINGS_DIR/recording_$(date +%Y%m%d_%H%M%S).mkv"
        gpu-screen-recorder -w DP-2 -f 60 -a default_output -c mkv -k hevc -o "$filename" &
        echo "$filename" > "$RECORDING_STATE"
        notify-send "Screen Recording" "Started recording DP-2" -t 2000
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
    *"Screen Recording"*)
        toggle_recording
        ;;
    *"Clear All Blurs"*)
        "$SCRIPTS/streaming-blur.sh" clear
        ;;
    *"Privacy Mode"*)
        privacy_menu
        ;;
    *"Expand Face"*)
        "$SCRIPTS/webcam-expand.sh" face
        ;;
    *"Expand Keyboard"*)
        "$SCRIPTS/webcam-expand.sh" topdown
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
