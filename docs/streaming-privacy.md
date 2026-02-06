# Streaming Privacy System

Automatic privacy blur for OBS streaming. Pixelates screen regions when sensitive files (`.env`, credentials, etc.) are open, protecting secrets during streams.

## Features

- **Auto-blur on .env files** - Neovim autocmds trigger blur when entering sensitive files
- **Window tracking** - Blur follows windows when moved/resized
- **Workspace awareness** - Blur hides when switching away from blurred window's workspace
- **Visual indicator** - Blurred windows get a red border
- **Manual toggle** - Keybind `Super+Alt+Ctrl+N` to toggle blur on any window
- **Hand cam blur** - Automatically blurs the top-down camera when privacy mode is active

## Architecture

```
┌─────────────┐    autocmd     ┌───────────────────┐             ┌─────────────────┐
│   Neovim    │ ─────────────► │ streaming-blur.sh │ ─────────► │ privacy-daemon  │
│ (BufEnter)  │  .env opened   │                   │   CLI      │   (Go binary)   │
└─────────────┘                │ • Get window pos  │            │                 │
                               │ • Scale coords    │            │ • OBS WebSocket │
                               └───────────────────┘            │ • Hyprland IPC  │
                                       │                        │ • Position poll │
                                       ▼                        └────────┬────────┘
                               ┌───────────────────┐                     │
                               │  hyprctl clients  │                     ▼
                               │  (window coords)  │            ┌─────────────────┐
                               └───────────────────┘            │  OBS WebSocket  │
                                                                │   (port 4455)   │
                                                                └────────┬────────┘
                                                                         │
                                                                         ▼
                                                                ┌─────────────────┐
                                                                │ obs-shaderfilter│
                                                                │  pixelator1-9   │
                                                                └─────────────────┘
```

## Components

### 1. Privacy Daemon (`~/projects/privacy-daemon/`)

Single Go binary that:
- Maintains persistent WebSocket connection to OBS
- Listens on Unix socket for blur commands
- Monitors Hyprland events for window/workspace changes
- Polls window positions every 100ms for drag/resize tracking
- Manages up to 9 simultaneous blur regions
- Tags windows for visual border indication

**Build:**
```bash
cd ~/projects/privacy-daemon
go build -o privacy-daemon .
```

**Run:**
```bash
./privacy-daemon          # Start daemon
./privacy-daemon blur <window_id> <x> <y> <w> <h>  # Blur a region
./privacy-daemon unblur <window_id>                 # Remove blur
./privacy-daemon clear                              # Clear all blurs
./privacy-daemon list                               # List active blurs
./privacy-daemon ping                               # Health check
```

### 2. Shell Script (`scripts/streaming-blur.sh`)

Client script that:
- Gets current terminal window position from Hyprland
- Scales coordinates from desktop (2560x1440) to OBS canvas (1920x1080)
- Sends commands to the daemon

**Usage:**
```bash
streaming-blur.sh on      # Blur current terminal + hand cam
streaming-blur.sh off     # Remove blur from current terminal
streaming-blur.sh toggle  # Toggle blur state
streaming-blur.sh clear   # Clear all blurs
streaming-blur.sh status  # Check blur state
```

### 3. Neovim Plugin (`.config/nvim/lua/plugins/streaming-privacy.lua`)

Autocmds that trigger blur for sensitive file patterns:
- `.env`, `*.env`, `.env.*`
- `*credentials*`, `*secret*`
- `*.pem`, `*.key`
- `*password*`

### 4. OBS Shader (`~/projects/privacy-daemon/privacy_pixelate.shader`)

Custom HLSL shader for obs-shaderfilter that pixelates a configurable rectangular region.

### 5. Hyprland Integration

**Keybind** (`.config/hypr/keybinds.conf`):
```
bind = $mainMod ALT CTRL, N, exec, ~/dotfiles/scripts/streaming-blur.sh toggle
```

**Window Rule** (`.config/hypr/windowrules.conf`):
```
windowrule {
    name = privacy-blur-border
    match:tag = privacy-blur
    border_color = rgb(ff5555)
}
```

### 6. Systemd Service (`.config/systemd/user/privacy-daemon.service`)

Auto-starts the daemon on login.

```bash
systemctl --user enable --now privacy-daemon.service
```

## OBS Setup

### Prerequisites

```bash
yay -S obs-shaderfilter
```

### Filter Setup

1. Open OBS, go to your desktop capture source (e.g., "main")
2. Right-click → Filters → + → User-defined shader
3. Create 9 filters named `pixelator1` through `pixelator9`
4. For each filter:
   - Load shader: `~/projects/privacy-daemon/privacy_pixelate.shader`
   - Disable by default (eye icon off)

### WebSocket Setup

1. Tools → WebSocket Server Settings
2. Enable server
3. **Disable authentication** (uncheck "Enable Authentication")
4. Default port: 4455

## Configuration

Settings in `~/.config/streaming/config.sh`:

```bash
# Monitor resolution (for coordinate scaling)
MONITOR_WIDTH=2560
MONITOR_HEIGHT=1440

# OBS canvas size
OBS_CANVAS_WIDTH=1920
OBS_CANVAS_HEIGHT=1080
```

## Customization

### Change blur border color

Edit `.config/hypr/windowrules.conf`:
```
border_color = rgb(ff5555)  # Change to any color
```

### Add more sensitive file patterns

Edit `.config/nvim/lua/plugins/streaming-privacy.lua` and add patterns to the `patterns` table.

### Change pixelation intensity

Edit `privacy_pixelate.shader` and modify `pixel_size` default value (higher = more pixelated).

## Troubleshooting

**Blur not appearing:**
- Check OBS WebSocket is enabled: Tools → WebSocket Server Settings
- Verify daemon is running: `pgrep privacy-daemon`
- Check daemon logs: `tail -f /tmp/privacy-daemon.log`

**Blur in wrong position:**
- Verify monitor resolution in config matches actual resolution
- Check OBS canvas size matches config

**Border color not changing:**
- Reload Hyprland config: `hyprctl reload`
- Check window has tag: `hyprctl clients | grep privacy-blur`

**Daemon won't connect to OBS:**
- Ensure OBS is running before starting daemon
- Check WebSocket authentication is disabled
