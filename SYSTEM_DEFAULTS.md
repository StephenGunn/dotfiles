# System Defaults Configuration

This document describes the default applications and system configurations for this Arch Linux setup.

## Default Applications

### Core Applications
- **File Manager**: Dolphin (KDE)
- **Web Browser**: Zen Browser
- **Terminal**: Ghostty
- **Text Editor**: Neovim
- **Image Viewer**: Krita (for editing), default viewer TBD
- **Video Player**: VLC

### Application Details

#### File Manager - Dolphin
- KDE's file manager
- Uses Qt/Kvantum for theming
- Invoked with: `Super + E`
- Package: `dolphin`

#### Web Browser - Zen Browser
- Firefox-based browser
- Default for all HTTP/HTTPS links
- Invoked with: `Super + B`
- Desktop entry: `zen.desktop`

#### Terminal - Ghostty
- Modern GPU-accelerated terminal
- Default terminal emulator
- Invoked with: `Super + Q`
- Package: `ghostty`

#### Text Editor - Neovim
- Default for text files
- Configured with lazy.nvim
- CLI command: `nvim`

## XDG Default Applications

The system uses XDG MIME types to determine default applications. Configuration is stored in:
- `~/.config/mimeapps.list`

### Current MIME Associations

```
# File Manager
inode/directory=org.kde.dolphin.desktop

# Web Browser
x-scheme-handler/http=zen.desktop
x-scheme-handler/https=zen.desktop
text/html=zen.desktop

# Text Editor
text/plain=nvim.desktop
text/x-shellscript=nvim.desktop
application/x-shellscript=nvim.desktop

# Images
image/jpeg=org.kde.krita.desktop
image/png=org.kde.krita.desktop
image/gif=org.kde.krita.desktop

# Videos
video/quicktime=vlc.desktop
```

## Qt/KDE Application Theming

Qt applications (like Dolphin) use Kvantum for theming.

### Requirements
```bash
# Required packages
yay -S kvantum kvantum-theme-catppuccin-git kvantum-theme-gruvbox-git
```

### Configuration Files
- **Kvantum Config**: `~/.config/Kvantum/kvantum.kvconfig`
- **Qt5 Settings**: `~/.config/qt5ct/qt5ct.conf` (if using qt5ct)
- **Qt6 Settings**: `~/.config/qt6ct/qt6ct.conf` (if using qt6ct)

### Environment Variables
These are set in `~/.config/hypr/hyprland.conf`:
```bash
env = QT_STYLE_OVERRIDE,kvantum
env = QT_QPA_PLATFORMTHEME,qt5ct  # Optional: for additional Qt settings
```

### Applying Themes to Dolphin
The theme switcher automatically:
1. Updates `~/.config/Kvantum/kvantum.kvconfig` with the theme name
2. Sets `QT_STYLE_OVERRIDE=kvantum` environment variable
3. Kvantum themes must be installed for each theme:
   - Catppuccin: `kvantum-theme-catppuccin-git`
   - Gruvbox: `kvantum-theme-gruvbox-git`
   - Nord: May need manual installation

### Manual Theme Application
If Dolphin isn't picking up the theme:
```bash
# Check current Kvantum theme
cat ~/.config/Kvantum/kvantum.kvconfig

# List available Kvantum themes
kvantummanager --list

# Set theme manually (requires restart of Qt apps)
kvantummanager --set <theme-name>

# Restart Dolphin to apply
killall dolphin
```

## GTK Application Theming

GTK applications use GTK themes configured in:
- `~/.config/gtk-3.0/settings.ini`
- `~/.config/gtk-4.0/settings.ini`
- `~/.gtkrc-2.0`

### Theme Packages
```bash
# Catppuccin
yay -S catppuccin-gtk-theme-mocha

# Gruvbox
yay -S colloid-gruvbox-gtk-theme-git

# Icons
yay -S breeze-icons

# Cursor
yay -S bibata-cursor-theme
```

## Setup Script

Run `./scripts/configure_system_defaults.sh` to:
1. Set XDG default applications
2. Verify theme packages are installed
3. Configure Qt/Kvantum settings
4. Test that all defaults work correctly

## Troubleshooting

### Dolphin Not Theming
1. Verify Kvantum theme is installed: `kvantummanager --list`
2. Check environment variable: `echo $QT_STYLE_OVERRIDE` (should be "kvantum")
3. Restart Dolphin: `killall dolphin && dolphin &`
4. Check Kvantum config: `cat ~/.config/Kvantum/kvantum.kvconfig`

### Wrong Application Opens
```bash
# Check what's registered
xdg-mime query default <mime-type>

# Example: Check file manager
xdg-mime query default inode/directory

# Set default manually
xdg-mime default org.kde.dolphin.desktop inode/directory
```

### Theme Not Applying After Switch
1. Restart affected applications
2. For Qt apps: `killall dolphin` (or other Qt app)
3. For GTK apps: Usually reload automatically
4. Check theme switcher logs for errors

## Related Files
- Hyprland config: `.config/hypr/hyprland.conf`
- Theme switcher: `~/projects/theme-switcher/scripts/theme-switch`
- Theme configs: `~/projects/theme-switcher/themes/*/config.json`
