#!/bin/bash
# Rofi menu for streaming controls
# Provides access to streaming mode, screenkey, and recording

CONFIG="$HOME/.config/streaming/config.sh"
[[ -f "$CONFIG" ]] && source "$CONFIG"

STATE_FILE="/tmp/streaming-mode-active"
RECORDING_STATE="/tmp/screen-recording-active"
RECORDINGS_DIR="$HOME/Videos/Recordings"
SCRIPTS="$HOME/dotfiles/scripts"

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
───────────────────
󰒓 Edit Config
󰑓 Restart Sidebar Daemon"

    echo "$options" | rofi -dmenu -i -p "Streaming" -theme-str 'window {width: 350px;}'
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
    *"Edit Config"*)
        ghostty -e "${EDITOR:-nvim}" "$CONFIG"
        ;;
    *"Restart Sidebar Daemon"*)
        pkill -f "streaming-scratchpad-daemon.sh" 2>/dev/null
        sleep 0.3
        "$SCRIPTS/streaming-scratchpad-daemon.sh" start &
        notify-send "Streaming" "Sidebar daemon restarted" -t 1500
        ;;
esac
