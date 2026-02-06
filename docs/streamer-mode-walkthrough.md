# Streamer Mode Walkthrough

## Concept
Hyprland manages all windows (cams, widgets) as real windows. OBS just captures the screen—no internal compositing.

## Layout
`Super+,` rofi menu controls everything. Streaming mode creates a sidebar via Hyprland gaps. Sidebar windows are floated, pinned, unfocusable.

Sidebar (top to bottom): face cam, keyboard cam (MPV h264), screenkey, swappable widget (bonsai/cmatrix/cava/pipes).

## Privacy System

**Signal flow:**
```
hyprctl (window geometry) → shell script → unix socket → Go daemon → OBS WebSocket → GLSL shader
```

- Go daemon holds persistent OBS WebSocket connection (Python cold-start was too slow)
- Scripts query hyprctl for window position, scale to OBS canvas coordinates
- Up to 9 blur regions, follow window on move/resize

**Triggers:**
- Neovim plugin: auto-blur on `.env`, `*.pem`, `*credentials*` (BufEnter/BufLeave)
- Manual: `Super+Alt+Ctrl+N` or rofi "Clear All Blurs"
- Cam blur: FFmpeg pixelize filter on MPV streams
