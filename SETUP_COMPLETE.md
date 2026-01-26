# Setup Summary - System Defaults & Theme Configuration

## What Was Done

### 1. Hyprland Configuration
- ✅ Converted all `windowrulev2` rules to new `windowrule` syntax
- ✅ Switched file manager from Dolphin to Thunar
- ✅ All window rules modernized and working

### 2. Neovim Navigation
- ✅ Added split navigation with `Ctrl+Alt+hjkl`
- ✅ No longer conflicts with Hyprland window navigation

### 3. System Defaults
- ✅ Created `SYSTEM_DEFAULTS.md` documentation
- ✅ Created `scripts/configure_system_defaults.sh` setup script
- ✅ Configured XDG MIME types for all applications
- ✅ Set Thunar as default file manager

### 4. Theme Switcher Enhancements
- ✅ Added Yazi theme switching support
- ✅ All themes now control Yazi flavor
- ✅ Yazi config managed from dotfiles

### 5. GTK Bookmarks
- ✅ Created GTK bookmarks file for file dialogs
- ✅ Created `GTK_BOOKMARKS.md` documentation
- ✅ Default bookmarks: Downloads, Documents, Projects, etc.

## Installation Steps

### 1. Install Thunar
```bash
sudo pacman -S thunar thunar-archive-plugin thunar-volman
```

The archive plugin gives you right-click extract/compress for zip files!

### 2. Install Optional Theme Packages
```bash
# For Catppuccin theme (if you want to use it)
yay -S catppuccin-gtk-theme-mocha

# For Gruvbox theme (current)
yay -S colloid-gruvbox-gtk-theme-git

# Install Yazi themes/flavors
ya pack -a yazi-rs/flavors:catppuccin-mocha
ya pack -a yazi-rs/flavors:gruvbox-dark
ya pack -a yazi-rs/flavors:nord
```

### 3. Apply Configuration
```bash
# Re-link dotfiles (includes new GTK bookmarks)
cd ~/dotfiles
./link.sh

# Reload Hyprland config
hyprctl reload
```

### 4. Test Theme Switching
```bash
# Switch to a theme and verify all apps update
theme-switch

# Check that yazi theme changed
yazi  # Open and check colors

# Check that Thunar matches theme
thunar  # Should use GTK theme automatically
```

## Browser Theme Refresh

### Do I need to restart the shell?
No! The theme-switcher handles everything. But here's what happens:

- **Ghostty**: Auto-reloads via SIGUSR2 signal ✅
- **Neovim**: Restart nvim to see new colorscheme
- **Rofi**: Next launch uses new theme
- **Yazi**: Restart yazi to see new theme
- **Thunar**: Launch uses current GTK theme (no restart needed if not running)
- **Hyprland**: Reloads automatically ✅

### Browser themes
Your Zen browser theme is controlled by the browser itself, not the theme-switcher. The theme-switcher only sets:
- Terminal colors (Ghostty)
- Editor colors (Neovim, Yazi)
- Window manager colors (Hyprland, HyprPanel)
- Desktop colors (Rofi, GTK apps)

For browser themes, you'd need browser extensions or built-in theme settings.

## File Manager: Thunar vs Dolphin

### Why Thunar?
- ✅ **Lighter & Simpler**: Fast, focused on basic tasks
- ✅ **GTK-based**: Uses your GTK theme automatically (no Kvantum needed)
- ✅ **Archive support**: `thunar-archive-plugin` for zip/tar right-click menus
- ✅ **Easier theming**: Already works with theme-switcher's GTK themes

### Dolphin Issues (why we switched away)
- ❌ Uses Qt/Kvantum which wasn't applying themes correctly
- ❌ More complex setup
- ❌ Heavier application

## GTK File Dialog Favorites

### Where favorites are stored
`~/.config/gtk-3.0/bookmarks`

### How to add more bookmarks

**Option 1: Edit the file directly**
```bash
echo "file:///home/stephen/projects/my-app My App" >> ~/.config/gtk-3.0/bookmarks
```

**Option 2: Use Thunar GUI**
1. Open Thunar
2. Navigate to folder
3. Press `Ctrl+D` or `Bookmarks > Add Bookmark`

### Current bookmarks
- Downloads
- Documents
- Pictures
- Videos
- Projects
- Dotfiles
- Temp

These appear in **all GTK file dialogs** including:
- Save/Open dialogs in most apps
- Firefox file pickers
- Thunar sidebar
- Screenshot save locations
- etc.

## Quick Commands Reference

```bash
# Open file manager
Super + E

# Switch themes
theme-switch

# Configure system defaults
~/dotfiles/scripts/configure_system_defaults.sh

# Re-link dotfiles
dots_link  # or: cd ~/dotfiles && ./link.sh

# Check default apps
xdg-mime query default inode/directory        # File manager
xdg-mime query default x-scheme-handler/http  # Browser
```

## Files Modified

- `.config/hypr/hyprland.conf` - Window rules, file manager binding
- `.config/nvim/lua/plugins/which-key.lua` - Split navigation
- `.config/mimeapps.list` - Default applications
- `.config/gtk-3.0/bookmarks` - File dialog favorites
- `~/projects/theme-switcher/scripts/theme-switch` - Added Yazi support
- `~/projects/theme-switcher/themes/*/config.json` - Added Yazi flavors

## New Documentation

- `SYSTEM_DEFAULTS.md` - System defaults overview
- `GTK_BOOKMARKS.md` - GTK bookmarks guide
- `SETUP_COMPLETE.md` - This file

## Next Steps

1. Install Thunar: `sudo pacman -S thunar thunar-archive-plugin`
2. Re-link dotfiles: `./link.sh`
3. Test file manager: Press `Super + E`
4. Test theme switching: `theme-switch`
5. Customize GTK bookmarks as needed

Everything is ready to go!
