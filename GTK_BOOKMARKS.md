# GTK Bookmarks & File Dialog Configuration

This guide explains how to set up favorite directories that appear in GTK file dialogs (used by most Linux applications including Thunar, Firefox save dialogs, etc.).

## GTK Bookmarks File

GTK applications read bookmarks from: `~/.config/gtk-3.0/bookmarks`

This is a simple text file where each line is a path (can include labels).

### Format

```
file:///full/path/to/directory Optional Label
```

### Example Configuration

Create or edit `~/.config/gtk-3.0/bookmarks`:

```bash
# Home directories
file:///home/stephen/Downloads Downloads
file:///home/stephen/Documents Documents
file:///home/stephen/Pictures Pictures
file:///home/stephen/Videos Videos
file:///home/stephen/Music Music

# Projects
file:///home/stephen/projects Projects
file:///home/stephen/dotfiles Dotfiles
file:///home/stephen/projects/theme-switcher Theme Switcher

# Common locations
file:///tmp Temporary Files
file:///mnt Mounted Drives

# Server paths (if mounted)
file:///mnt/server Server
```

## Thunar Bookmarks

Thunar also uses GTK bookmarks, but you can also manage them through the GUI:

1. Open Thunar
2. Navigate to the folder you want to bookmark
3. Press `Ctrl+D` or go to `Bookmarks > Add Bookmark`
4. These will automatically be added to `~/.config/gtk-3.0/bookmarks`

## Qt File Dialogs (for Qt apps like Dolphin)

Qt applications use a different system. They store bookmarks in:
- `~/.local/share/user-places.xbel` (shared with KDE apps)

However, since we're switching to Thunar (GTK), we don't need to worry about this.

## Updating Your Bookmarks

I'll create a default bookmarks file in your dotfiles that will be symlinked.

### Quick Access Shortcuts in Thunar

Thunar sidebar shortcuts come from:
1. **GTK Bookmarks**: `~/.config/gtk-3.0/bookmarks`
2. **XDG User Dirs**: `~/.config/user-dirs.dirs` (for standard directories like Downloads, Documents)

## XDG User Directories

Edit `~/.config/user-dirs.dirs` to set standard folder locations:

```bash
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_VIDEOS_DIR="$HOME/Videos"
```

These will automatically appear in GTK file dialogs.

## Applying Changes

Changes take effect immediately for new file dialogs. If a dialog is already open, close and reopen it.

## Tips

1. **Use absolute paths** - Always use `file:///` prefix with full paths
2. **Labels are optional** - You can omit them and the folder name will be used
3. **Keep it organized** - Group related bookmarks with comments
4. **Sync with dotfiles** - Add bookmarks to your dotfiles repo so they persist

## Related Files

- GTK Bookmarks: `.config/gtk-3.0/bookmarks`
- User Dirs: `.config/user-dirs.dirs`
- Thunar settings: `.config/Thunar/`

## Notes on Dolphin vs Thunar

- **Dolphin** (Qt/KDE): More features, file previews, split views, but requires Qt theming (Kvantum)
- **Thunar** (GTK/XFCE): Lighter, simpler, uses GTK themes (already working with your theme-switcher)

Since Thunar uses GTK, it will automatically match your GTK theme (Gruvbox, Catppuccin, etc.) without additional configuration!
