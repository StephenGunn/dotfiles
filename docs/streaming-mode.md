# Streaming Mode Plan

A toggleable "streaming mode" that creates a persistent sidebar with webcams and keystroke display, managed entirely by Hyprland - keeping OBS simple (just capture the whole monitor).

## Concept

```
┌─────────────────────────────────────────────────────────────────────┐
│                           HyprPanel                                 │
├──────────────────────────────────────────────┬──────────────────────┤
│                                              │                      │
│                                              │    Keystroke         │
│                                              │    Display           │
│                                              │    (screenkey)       │
│                                              │                      │
│            Main Content Area                 ├──────────────────────┤
│            (workspaces tile here)            │                      │
│                                              │    Top-down          │
│            Reserved area shrinks             │    Webcam            │
│            this automatically                │    (keyboard/desk)   │
│                                              │                      │
│                                              ├──────────────────────┤
│                                              │                      │
│                                              │    Face              │
│                                              │    Webcam            │
│                                              │                      │
└──────────────────────────────────────────────┴──────────────────────┘
        ← 2160px (main content) →              ← 400px (sidebar) →
```

## Key Hyprland Features Used

### 1. Monitor Reserved Area
Carves out space on the right that tiling windows won't use:
```bash
# Runtime toggle via hyprctl
hyprctl keyword monitor DP-2,2560x1440@165,0x0,1,reserved:0 400 0 0
# Reset to normal
hyprctl keyword monitor DP-2,2560x1440@165,0x0,1
```

### 2. Pinned Windows
Windows with `pin` are visible on ALL workspaces on that monitor:
```bash
hyprctl dispatch pin        # Toggle pin on focused window
```

### 3. Window Rules (runtime)
Position and size windows dynamically:
```bash
hyprctl keyword windowrulev2 "float,title:^(webcam-.*)$"
hyprctl keyword windowrulev2 "pin,title:^(webcam-.*)$"
hyprctl keyword windowrulev2 "move 2170 60,title:^(webcam-keys)$"
```

## Components

### Webcam Display
**Tool**: `mpv` with H264 hardware decode (lowest latency tested)

```bash
# Optimal low-latency command (H264 with GPU decode)
mpv --profile=low-latency \
    --untimed \
    --no-cache \
    --demuxer-lavf-o=fflags=+nobuffer \
    --demuxer-lavf-analyzeduration=0 \
    --demuxer-lavf-probesize=32 \
    --demuxer-lavf-o=input_format=h264,video_size=1920x1080,framerate=60 \
    --msg-level=ffmpeg=error \
    --no-osc --no-border \
    --title="webcam-face" \
    --geometry=380x285+2170+755 \
    av://v4l2:/dev/video0

# Top-down webcam (adjust device path)
mpv --profile=low-latency \
    --untimed \
    --no-cache \
    --demuxer-lavf-o=fflags=+nobuffer \
    --demuxer-lavf-analyzeduration=0 \
    --demuxer-lavf-probesize=32 \
    --demuxer-lavf-o=input_format=h264,video_size=1920x1080,framerate=60 \
    --msg-level=ffmpeg=error \
    --no-osc --no-border \
    --title="webcam-topdown" \
    --geometry=380x285+2170+410 \
    av://v4l2:/dev/video2
```

**Alternative formats** (if H264 doesn't work on a camera):
```bash
# MJPEG fallback
--demuxer-lavf-o=input_format=mjpeg,video_size=1920x1080,framerate=60
```

### Keystroke Display
**Tool**: `screenkey` (most configurable) or `showmethekey` (newer, GTK4)

```bash
# screenkey - lots of options
screenkey --position fixed \
          --geometry 380x120+2170+60 \
          --font-size medium \
          --timeout 2 \
          --no-systray \
          --window-id $(xdotool search --name "keystroke-display")

# Alternative: showmethekey-gtk (newer, Wayland-native)
showmethekey-gtk
```

**Password safety options for screenkey:**
- `--timeout 2` - keys disappear after 2 seconds
- `--key-mode raw` - shows actual keys (careful!)
- `--key-mode translated` - shows translated keys
- Pause with mouse click on the window
- Could add a hotkey to toggle screenkey on/off independently

### Alternative: Custom AGS Widget
Since you already use HyprPanel (AGS-based), you could create a custom widget that:
- Shows keystrokes via libinput events
- Has a "pause" button
- Auto-hides during password prompts (detect focused window class)

This would be more integrated but more work.

## Toggle Script

### `scripts/streaming-mode.sh`
```bash
#!/bin/bash
# Toggle streaming mode on/off

STATE_FILE="/tmp/streaming-mode-active"
SIDEBAR_WIDTH=400
MAIN_CONTENT_X=$((2560 - SIDEBAR_WIDTH))  # 2160

# Window positions (right edge of main content + padding)
SIDEBAR_X=$((MAIN_CONTENT_X + 10))  # 2170

streaming_on() {
    # Reserve space on right side of main monitor
    hyprctl keyword monitor "DP-2,2560x1440@165,0x0,1,reserved:0 ${SIDEBAR_WIDTH} 0 0"

    # Launch keystroke display
    screenkey --position fixed \
              --geometry "380x150+${SIDEBAR_X}+60" \
              --font-size medium \
              --timeout 3 \
              --no-systray &

    # Launch face webcam
    mpv --no-osc --no-border --no-input-default-bindings \
        --title="webcam-face" \
        --geometry="380x285+${SIDEBAR_X}+755" \
        --profile=low-latency \
        av://v4l2:/dev/video0 &

    # Launch top-down webcam (adjust device if needed)
    # mpv --no-osc --no-border --no-input-default-bindings \
    #     --title="webcam-topdown" \
    #     --geometry="380x285+${SIDEBAR_X}+410" \
    #     --profile=low-latency \
    #     av://v4l2:/dev/video2 &

    sleep 0.5

    # Pin the webcam windows so they persist across workspaces
    hyprctl dispatch pin "title:^(webcam-.*)"

    # Mark as active
    touch "$STATE_FILE"
    notify-send "Streaming Mode" "Enabled" -i camera-video
}

streaming_off() {
    # Kill streaming windows
    pkill -f "screenkey"
    pkill -f "mpv.*webcam"

    # Reset monitor (remove reserved area)
    hyprctl keyword monitor "DP-2,2560x1440@165,0x0,1"

    # Remove state file
    rm -f "$STATE_FILE"
    notify-send "Streaming Mode" "Disabled" -i camera-video-off
}

# Toggle based on current state
if [[ -f "$STATE_FILE" ]]; then
    streaming_off
else
    streaming_on
fi
```

## Keybind

Add to `keybinds.conf`:
```bash
# Streaming mode toggle
bind = $mainMod SHIFT, F12, exec, ~/dotfiles/scripts/streaming-mode.sh

# Quick toggle just screenkey (for password safety)
bind = $mainMod CTRL, F12, exec, pkill screenkey || screenkey --position fixed --geometry "380x150+2170+60" --timeout 3 --no-systray
```

## Window Rules

Add to `windowrules.conf`:
```bash
###################
### STREAMING   ###
###################

# Webcam windows - float, pin, no focus steal
windowrule {
    name = streaming-webcams
    match:title = ^(webcam-.*)$

    float = on
    pin = on
    nofocus = on
    noborder = on
}

# Screenkey window
windowrule {
    name = streaming-screenkey
    match:class = ^(Screenkey)$

    float = on
    pin = on
    nofocus = on
    noborder = on
}
```

## File Structure

```
dotfiles/
├── .config/hypr/
│   ├── windowrules.conf      # Add streaming window rules
│   └── keybinds.conf         # Add streaming keybind
└── scripts/
    └── streaming-mode.sh     # Toggle script
```

## OBS Setup

With this approach, OBS becomes trivial:
1. Add a single "Screen Capture" source for DP-2
2. That's it - webcams, keystrokes, and content are all composed by Hyprland

Optional: Use "Window Capture" for just the main content area if you want different layouts for different scenes.

## Hardware Requirements

- [ ] Identify webcam devices: `ls -la /dev/video*` and `v4l2-ctl --list-devices`
- [ ] Test webcam with mpv: `mpv av://v4l2:/dev/video0`
- [ ] Install screenkey: `paru -S screenkey` or `showmethekey-gtk`

---

## OBSBOT Camera Control (Linux)

OBSBOT cameras (Tiny, Meet, etc.) expose full PTZ control via standard UVC protocol - no official app needed.

### Check Camera Capabilities
```bash
# List supported formats and resolutions
v4l2-ctl -d /dev/video0 --list-formats-ext

# List all controls
v4l2-ctl -d /dev/video0 --list-ctrls-menus
```

### Available Controls

| Control | Range | Description |
|---------|-------|-------------|
| `pan_absolute` | -468000 to 468000 (step 3600) | Horizontal rotation |
| `tilt_absolute` | -324000 to 324000 (step 3600) | Vertical rotation |
| `zoom_absolute` | 0 to 100 | Zoom level |
| `pan_speed` | -1 to 80 | Pan movement speed |
| `tilt_speed` | -1 to 120 | Tilt movement speed |
| `brightness` | 0 to 100 | Image brightness |
| `contrast` | 1 to 100 | Image contrast |
| `saturation` | 1 to 100 | Color saturation |
| `sharpness` | 1 to 100 | Image sharpness |
| `auto_exposure` | 0=Auto, 1=Manual, 3=Aperture | Exposure mode |
| `exposure_time_absolute` | 1 to 2500 | Manual exposure (when not auto) |
| `white_balance_automatic` | 0/1 | Auto white balance toggle |
| `white_balance_temperature` | 2000 to 10000 | Manual WB (when not auto) |
| `focus_automatic_continuous` | 0/1 | Auto focus toggle |
| `focus_absolute` | 0 to 100 | Manual focus (when not auto) |
| `backlight_compensation` | 0 to 18 | Backlight compensation |

### Basic PTZ Commands
```bash
# Zoom
v4l2-ctl -d /dev/video0 --set-ctrl=zoom_absolute=0    # Wide
v4l2-ctl -d /dev/video0 --set-ctrl=zoom_absolute=50   # Medium
v4l2-ctl -d /dev/video0 --set-ctrl=zoom_absolute=100  # Close

# Pan (negative=left, positive=right)
v4l2-ctl -d /dev/video0 --set-ctrl=pan_absolute=-200000  # Pan left
v4l2-ctl -d /dev/video0 --set-ctrl=pan_absolute=0        # Center
v4l2-ctl -d /dev/video0 --set-ctrl=pan_absolute=200000   # Pan right

# Tilt (negative=down, positive=up)
v4l2-ctl -d /dev/video0 --set-ctrl=tilt_absolute=-150000  # Tilt down
v4l2-ctl -d /dev/video0 --set-ctrl=tilt_absolute=0        # Center
v4l2-ctl -d /dev/video0 --set-ctrl=tilt_absolute=150000   # Tilt up

# Reset to center
v4l2-ctl -d /dev/video0 --set-ctrl=pan_absolute=0 --set-ctrl=tilt_absolute=0 --set-ctrl=zoom_absolute=0

# Multiple controls at once
v4l2-ctl -d /dev/video0 \
    --set-ctrl=pan_absolute=0 \
    --set-ctrl=tilt_absolute=0 \
    --set-ctrl=zoom_absolute=30 \
    --set-ctrl=brightness=55
```

### Image Quality Presets
```bash
# Bright/vibrant look
v4l2-ctl -d /dev/video0 \
    --set-ctrl=brightness=55 \
    --set-ctrl=contrast=55 \
    --set-ctrl=saturation=60 \
    --set-ctrl=sharpness=60

# Natural/neutral look
v4l2-ctl -d /dev/video0 \
    --set-ctrl=brightness=50 \
    --set-ctrl=contrast=50 \
    --set-ctrl=saturation=50 \
    --set-ctrl=sharpness=50

# Low-light (boost gain, reduce noise)
v4l2-ctl -d /dev/video0 \
    --set-ctrl=auto_exposure=0 \
    --set-ctrl=backlight_compensation=12 \
    --set-ctrl=sharpness=40
```

### OBSBOT AI Tracking (Gestures)

The AI tracking runs on the camera firmware - works regardless of OS:

| Gesture | Action |
|---------|--------|
| ✋ Palm facing camera | Stop tracking / Lock position |
| 👆 Hand up (finger pointing up) | Start tracking |
| 👌 OK sign | Zoom in |
| ✌️ Peace sign | Zoom out |
| 🤟 "Rock on" (index + pinky) | Toggle tracking mode |

Note: Gesture availability depends on OBSBOT model and firmware.

---

## Stream Deck Integration

Stream Deck can execute shell commands, making it perfect for camera control.

### Option 1: Direct Commands

Configure Stream Deck buttons to run shell commands directly:

| Button | Command |
|--------|---------|
| Reset Camera | `v4l2-ctl -d /dev/video0 --set-ctrl=pan_absolute=0 --set-ctrl=tilt_absolute=0 --set-ctrl=zoom_absolute=0` |
| Zoom In | `v4l2-ctl -d /dev/video0 --set-ctrl=zoom_absolute=60` |
| Zoom Out | `v4l2-ctl -d /dev/video0 --set-ctrl=zoom_absolute=0` |
| Pan Left | `v4l2-ctl -d /dev/video0 --set-ctrl=pan_absolute=-150000` |
| Pan Right | `v4l2-ctl -d /dev/video0 --set-ctrl=pan_absolute=150000` |
| Toggle Streaming Mode | `~/dotfiles/scripts/streaming-mode.sh` |
| Toggle Screenkey | `pkill screenkey \|\| screenkey --position fixed --geometry "380x150+2170+60" --timeout 3 --no-systray` |

### Option 2: Helper Script with Presets

Create `scripts/camera-control.sh`:
```bash
#!/bin/bash
# Camera control helper for Stream Deck
# Usage: camera-control.sh <device> <preset>

DEVICE="${1:-/dev/video0}"
PRESET="${2:-reset}"

case "$PRESET" in
    reset|center)
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=pan_absolute=0 \
            --set-ctrl=tilt_absolute=0 \
            --set-ctrl=zoom_absolute=0
        ;;
    zoom-in|close)
        v4l2-ctl -d "$DEVICE" --set-ctrl=zoom_absolute=70
        ;;
    zoom-out|wide)
        v4l2-ctl -d "$DEVICE" --set-ctrl=zoom_absolute=0
        ;;
    zoom-medium)
        v4l2-ctl -d "$DEVICE" --set-ctrl=zoom_absolute=35
        ;;
    keyboard)
        # Preset: looking down at keyboard
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=pan_absolute=0 \
            --set-ctrl=tilt_absolute=-200000 \
            --set-ctrl=zoom_absolute=40
        ;;
    desk)
        # Preset: desk overview
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=pan_absolute=0 \
            --set-ctrl=tilt_absolute=-100000 \
            --set-ctrl=zoom_absolute=20
        ;;
    face)
        # Preset: face cam position
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=pan_absolute=0 \
            --set-ctrl=tilt_absolute=0 \
            --set-ctrl=zoom_absolute=30
        ;;
    bright)
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=brightness=55 \
            --set-ctrl=contrast=55 \
            --set-ctrl=saturation=60
        ;;
    natural)
        v4l2-ctl -d "$DEVICE" \
            --set-ctrl=brightness=50 \
            --set-ctrl=contrast=50 \
            --set-ctrl=saturation=50
        ;;
    *)
        echo "Unknown preset: $PRESET"
        echo "Available: reset, zoom-in, zoom-out, zoom-medium, keyboard, desk, face, bright, natural"
        exit 1
        ;;
esac
```

Then Stream Deck buttons just call:
```bash
~/dotfiles/scripts/camera-control.sh /dev/video0 keyboard
~/dotfiles/scripts/camera-control.sh /dev/video0 face
~/dotfiles/scripts/camera-control.sh /dev/video2 desk
```

### Stream Deck Software on Linux

- **streamdeck-ui** (Python/Qt) - `paru -S streamdeck-ui`
- **deckmaster** (Go) - lightweight alternative
- **boatswain** (GNOME) - GTK4 native

### Hyprland Keybinds (Alternative to Stream Deck)

```bash
# Camera presets
bind = $mainMod CTRL, 1, exec, ~/dotfiles/scripts/camera-control.sh /dev/video0 reset
bind = $mainMod CTRL, 2, exec, ~/dotfiles/scripts/camera-control.sh /dev/video0 face
bind = $mainMod CTRL, 3, exec, ~/dotfiles/scripts/camera-control.sh /dev/video0 keyboard
bind = $mainMod CTRL, 4, exec, ~/dotfiles/scripts/camera-control.sh /dev/video0 zoom-in

# Streaming mode
bind = $mainMod SHIFT, F12, exec, ~/dotfiles/scripts/streaming-mode.sh
```

---

## Camera Device Mapping

Identify which `/dev/video*` is which camera:

```bash
v4l2-ctl --list-devices
```

Example output:
```
OBSBOT Tiny 4K (usb-0000:00:14.0-1):
    /dev/video0
    /dev/video1
    /dev/media0

OBSBOT Meet (usb-0000:00:14.0-2):
    /dev/video2
    /dev/video3
    /dev/media1
```

Note: Device numbers can change on reboot. For consistent naming, create udev rules:

```bash
# /etc/udev/rules.d/99-webcams.rules
SUBSYSTEM=="video4linux", ATTRS{product}=="OBSBOT Tiny 4K", ATTR{index}=="0", SYMLINK+="webcam-face"
SUBSYSTEM=="video4linux", ATTRS{product}=="OBSBOT Meet", ATTR{index}=="0", SYMLINK+="webcam-topdown"
```

Then use `/dev/webcam-face` and `/dev/webcam-topdown` instead of `/dev/video0`.

## Future Enhancements

1. **Multiple profiles** - different sidebar layouts for different content types
2. **AGS integration** - custom keystroke widget with pause button
3. **Auto-pause on password fields** - detect password inputs and hide screenkey
4. **Scene switching** - different reserved areas for different streaming scenarios
5. **Audio visualizer widget** - show audio levels in sidebar
6. **Chat overlay** - Twitch/YouTube chat as a pinned window

## Testing Checklist

- [ ] Verify monitor reserved area works and windows tile correctly
- [ ] Test webcam launches and displays correctly
- [ ] Verify pinned windows persist across workspace switches
- [ ] Test toggle on/off multiple times
- [ ] Verify OBS captures everything correctly
- [ ] Test screenkey password safety (timeout, manual pause)

## Alternative: Dedicated Streaming User

Instead of a toggle script, you could create a separate Linux user for streaming.

### Pros
- **Complete isolation** - streaming user has its own config, no accidental leaks
- **No password risk** - streaming user doesn't have access to your password manager, SSH keys, etc.
- **Cleaner configs** - streaming user's Hyprland config is *always* in streaming mode
- **Different theme/layout** - streaming-specific HyprPanel, wallpapers, etc.
- **Easy reset** - mess something up? Just reset the streaming user's dotfiles

### Cons
- **Session switching** - need to logout/login (or use a second TTY with a second Hyprland session?)
- **File access** - streaming user needs read access to your projects
  - Solution: Add streaming user to your group, or use a shared `/projects` directory
- **Two configs to maintain** - though you could symlink shared parts

### Hybrid Approach
Could do both:
1. **Quick streaming** - use the toggle script on your main user for casual streams
2. **Serious streaming** - login as streaming user for longer sessions where you want full isolation

### Setup Steps (if going this route)
```bash
# Create streaming user
sudo useradd -m -G video,audio,input streaming
sudo passwd streaming

# Give access to your projects (option 1: add to your group)
sudo usermod -aG stephen streaming

# Or option 2: shared directory with ACLs
sudo setfacl -R -m u:streaming:rx ~/projects

# Copy/symlink dotfiles
sudo -u streaming git clone ~/dotfiles /home/streaming/dotfiles
sudo -u streaming /home/streaming/dotfiles/link.sh

# Modify streaming user's hyprland config to always have streaming layout
```

Then the streaming user's `hosts/jovian.conf` would have the reserved area baked in, and `autostart.conf` would launch webcams automatically.

## Notes

- The `pin` feature makes windows visible on ALL workspaces on that monitor
- Reserved area prevents tiling windows from overlapping the sidebar
- `mpv` is preferred over `ffplay` for lower latency and better Wayland support
- Screenkey may need `--mods-mode` flag tweaking for your preference
- Consider `--no-input-default-bindings` on mpv to prevent accidental interaction
