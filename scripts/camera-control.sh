#!/bin/bash
# Camera control helper for OBSBOT cameras
# Usage: camera-control.sh [device] <preset>
#
# If device is omitted, uses CAM_FACE from config
# Presets: reset, zoom-in, zoom-out, zoom-medium, keyboard, desk, face, bright, natural

CONFIG="$HOME/.config/streaming/config.sh"
[[ -f "$CONFIG" ]] && source "$CONFIG"

# Parse arguments
if [[ "$1" == /dev/* ]]; then
    DEVICE="$1"
    PRESET="${2:-reset}"
else
    DEVICE="${CAM_FACE:-/dev/video0}"
    PRESET="${1:-reset}"
fi

# Check device exists
if [[ ! -e "$DEVICE" ]]; then
    notify-send "Camera Control" "Device not found: $DEVICE" -u critical
    exit 1
fi

case "$PRESET" in
    reset|center)
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=pan_absolute=0 \
            --set-ctrl=tilt_absolute=0 \
            --set-ctrl=zoom_absolute=0
        notify-send "Camera" "Reset to center" -t 1500
        ;;
    zoom-in|close)
        v4l2-ctl -d "$DEVICE" --set-ctrl=zoom_absolute=70
        notify-send "Camera" "Zoomed in" -t 1500
        ;;
    zoom-out|wide)
        v4l2-ctl -d "$DEVICE" --set-ctrl=zoom_absolute=0
        notify-send "Camera" "Zoomed out (wide)" -t 1500
        ;;
    zoom-medium|medium)
        v4l2-ctl -d "$DEVICE" --set-ctrl=zoom_absolute=35
        notify-send "Camera" "Medium zoom" -t 1500
        ;;
    keyboard)
        # Looking down at keyboard
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=pan_absolute=0 \
            --set-ctrl=tilt_absolute=-200000 \
            --set-ctrl=zoom_absolute=40
        notify-send "Camera" "Keyboard view" -t 1500
        ;;
    desk)
        # Desk overview
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=pan_absolute=0 \
            --set-ctrl=tilt_absolute=-100000 \
            --set-ctrl=zoom_absolute=20
        notify-send "Camera" "Desk view" -t 1500
        ;;
    face)
        # Face cam position
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=pan_absolute=0 \
            --set-ctrl=tilt_absolute=0 \
            --set-ctrl=zoom_absolute=30
        notify-send "Camera" "Face view" -t 1500
        ;;
    bright)
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=brightness=55 \
            --set-ctrl=contrast=55 \
            --set-ctrl=saturation=60 \
            --set-ctrl=sharpness=60
        notify-send "Camera" "Bright preset" -t 1500
        ;;
    natural)
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=brightness=50 \
            --set-ctrl=contrast=50 \
            --set-ctrl=saturation=50 \
            --set-ctrl=sharpness=50
        notify-send "Camera" "Natural preset" -t 1500
        ;;
    # Incremental controls
    pan-left)
        current=$(v4l2-ctl -d "$DEVICE" --get-ctrl=pan_absolute | cut -d'=' -f2)
        new=$((current - 50000))
        v4l2-ctl -d "$DEVICE" --set-ctrl=pan_absolute=$new
        ;;
    pan-right)
        current=$(v4l2-ctl -d "$DEVICE" --get-ctrl=pan_absolute | cut -d'=' -f2)
        new=$((current + 50000))
        v4l2-ctl -d "$DEVICE" --set-ctrl=pan_absolute=$new
        ;;
    tilt-up)
        current=$(v4l2-ctl -d "$DEVICE" --get-ctrl=tilt_absolute | cut -d'=' -f2)
        new=$((current + 50000))
        v4l2-ctl -d "$DEVICE" --set-ctrl=tilt_absolute=$new
        ;;
    tilt-down)
        current=$(v4l2-ctl -d "$DEVICE" --get-ctrl=tilt_absolute | cut -d'=' -f2)
        new=$((current - 50000))
        v4l2-ctl -d "$DEVICE" --set-ctrl=tilt_absolute=$new
        ;;
    zoom+)
        current=$(v4l2-ctl -d "$DEVICE" --get-ctrl=zoom_absolute | cut -d'=' -f2)
        new=$((current + 10))
        [[ $new -gt 100 ]] && new=100
        v4l2-ctl -d "$DEVICE" --set-ctrl=zoom_absolute=$new
        ;;
    zoom-)
        current=$(v4l2-ctl -d "$DEVICE" --get-ctrl=zoom_absolute | cut -d'=' -f2)
        new=$((current - 10))
        [[ $new -lt 0 ]] && new=0
        v4l2-ctl -d "$DEVICE" --set-ctrl=zoom_absolute=$new
        ;;
    status)
        echo "Device: $DEVICE"
        v4l2-ctl -d "$DEVICE" --get-ctrl=pan_absolute,tilt_absolute,zoom_absolute,brightness,contrast
        ;;
    *)
        echo "Unknown preset: $PRESET"
        echo ""
        echo "Usage: camera-control.sh [device] <preset>"
        echo ""
        echo "Position presets:"
        echo "  reset, center    - Center position, no zoom"
        echo "  face             - Face cam (slight zoom)"
        echo "  keyboard         - Looking down at keyboard"
        echo "  desk             - Desk overview"
        echo ""
        echo "Zoom presets:"
        echo "  zoom-in, close   - Close zoom (70)"
        echo "  zoom-medium      - Medium zoom (35)"
        echo "  zoom-out, wide   - No zoom (0)"
        echo ""
        echo "Image presets:"
        echo "  bright           - Vibrant colors"
        echo "  natural          - Neutral colors"
        echo ""
        echo "Incremental:"
        echo "  pan-left, pan-right, tilt-up, tilt-down"
        echo "  zoom+, zoom-"
        echo ""
        echo "Info:"
        echo "  status           - Show current values"
        exit 1
        ;;
esac
