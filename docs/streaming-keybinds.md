# Streaming Mode Keybinds

## Hyprland Keybinds

| Keybind | Action |
|---------|--------|
| `Super + ,` | Open streaming rofi menu |
| `Super + Shift + ,` | Toggle face cam expand (sidebar ↔ fullscreen) |
| `Super + Ctrl + ,` | Toggle keyboard cam expand (sidebar ↔ fullscreen) |
| `Super + Alt + Ctrl + N` | Toggle privacy blur on active terminal |

## Rofi Streaming Menu (`Super + ,`)

The rofi menu provides access to everything else:

- **Toggle Streaming Mode** — launch/kill sidebar with webcams + widget
- **Screenkey Toggle** — show/hide keystroke display
- **Privacy Mode** — submenu for camera pixelation and content blur
- **Expand Face Cam / Keyboard Cam** — same as the keybinds above
- **Face Camera / Top-down Camera** — PTZ controls (pan, tilt, zoom, presets)
- **Camera Presets** — quick layouts (reset all, face position, desk setup, standard stream)
- **Image Settings** — brightness/color presets (bright, natural) per camera or both
- **Edit Config** — opens `~/.config/streaming/config.sh` in nvim
- **Swap Cameras** — swap face/topdown device assignments and restart cams

## Automatic Triggers

Neovim auto-enables privacy blur when opening sensitive files while streaming mode is active and OBS is running:

- `.env`, `*.env`
- `*.key`
- `*credentials*`, `*secret*`, `*password*`

Blur is removed automatically when leaving the buffer.
