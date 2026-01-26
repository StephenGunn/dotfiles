# Syncing Bookmarks Across Programs

This guide explains how different file managers and applications store bookmarks, and how to keep them in sync.

## 🎯 Source of Truth: Thunar (GTK Bookmarks)

**Our system uses Thunar as the authoritative source for bookmarks.**

- **Primary file**: `~/.config/gtk-3.0/bookmarks` (managed in dotfiles)
- **Sync direction**: GTK bookmarks → Qt bookmarks (one-way)
- **Why**: Thunar and most Linux apps use GTK, so managing bookmarks here covers 90% of use cases

**To add/modify bookmarks:**
1. Use Thunar GUI (press `Ctrl+D` in a folder)
2. OR edit `~/.config/gtk-3.0/bookmarks` directly
3. Run `~/dotfiles/scripts/sync_bookmarks.sh` if you use Qt apps (optional)

## Overview: Bookmark Storage by Program

Different programs use different bookmark systems:

| Program | Bookmark Storage | Format | Syncs With |
|---------|-----------------|--------|------------|
| **Thunar** | `~/.config/gtk-3.0/bookmarks` | GTK Bookmarks | All GTK apps |
| **Nautilus** | `~/.config/gtk-3.0/bookmarks` | GTK Bookmarks | All GTK apps |
| **Nemo** | `~/.config/gtk-3.0/bookmarks` | GTK Bookmarks | All GTK apps |
| **Dolphin** | `~/.local/share/user-places.xbel` | XBel XML | Qt/KDE apps |
| **PCManFM** | `~/.config/gtk-3.0/bookmarks` | GTK Bookmarks | All GTK apps |
| **Yazi** | Manual config | TOML | None |
| **Firefox** | File picker uses GTK | GTK Bookmarks | All GTK apps |
| **Rofi file browser** | Uses GTK | GTK Bookmarks | All GTK apps |

## The Two Main Systems

### 1. GTK Bookmarks (Most Common)
**File**: `~/.config/gtk-3.0/bookmarks`

Used by:
- All GTK file managers (Thunar, Nautilus, Nemo, PCManFM)
- GTK file dialogs (Firefox, Chrome, most Linux apps)
- Any application using GTK's file chooser

**Format**:
```
file:///home/stephen/Downloads Downloads
file:///home/stephen/projects Projects
```

### 2. Qt/KDE Bookmarks (Dolphin, Qt apps)
**File**: `~/.local/share/user-places.xbel`

Used by:
- KDE applications (Dolphin, Krita, Kate)
- Qt file dialogs
- Any application using Qt's file chooser

**Format**: XML (XBel format)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xbel>
<xbel xmlns:bookmark="http://www.freedesktop.org/standards/bookmark" xmlns:kdepriv="http://www.kde.org/kdepriv" xmlns:mime="http://www.freedesktop.org/standards/shared-mime-info">
 <bookmark href="file:///home/stephen/Downloads">
  <title>Downloads</title>
 </bookmark>
</xbel>
```

## How to Keep Them in Sync

Since you're using Thunar (GTK), the good news is **most applications will automatically use your GTK bookmarks**!

### Strategy 1: Use GTK as the Source of Truth (Recommended)

Since you're using Thunar and most Linux apps use GTK file dialogs, maintain your bookmarks in:
```
~/.config/gtk-3.0/bookmarks
```

This will automatically work in:
- ✅ Thunar
- ✅ Firefox/Zen file dialogs
- ✅ Most application file dialogs
- ✅ Any GTK-based program

### Strategy 2: Create a Sync Script (If you also use Qt/KDE apps)

I'll create a script that syncs GTK bookmarks to Qt format.

## XDG User Directories (Always Synced)

**File**: `~/.config/user-dirs.dirs`

These standard directories appear in **all** file managers automatically:

```bash
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_VIDEOS_DIR="$HOME/Videos"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_TEMPLATES_DIR="$HOME/Templates"
```

These are respected by **both** GTK and Qt applications!

## Managing Bookmarks

### Method 1: Edit GTK Bookmarks Directly (Easiest)

```bash
# Edit your bookmarks file
nvim ~/.config/gtk-3.0/bookmarks

# Add bookmarks (one per line)
file:///home/stephen/projects/my-app My App
file:///mnt/server Server Files
file:///tmp/downloads Temp Downloads
```

Changes take effect immediately in new file dialogs.

### Method 2: Use Thunar GUI

1. Open Thunar
2. Navigate to the folder
3. Press `Ctrl+D` or click `Bookmarks > Add Bookmark`
4. Automatically updates `~/.config/gtk-3.0/bookmarks`

### Method 3: Use a Bookmark Manager Script

See the sync script section below.

## Bookmark Sync Script

For users who want to sync between GTK and Qt formats:

### Location
`~/dotfiles/scripts/sync_bookmarks.sh`

### What it does
1. Reads GTK bookmarks (`~/.config/gtk-3.0/bookmarks`)
2. Converts to Qt format
3. Writes to `~/.local/share/user-places.xbel`
4. Both systems now have the same bookmarks

### Usage
```bash
# Sync bookmarks (GTK → Qt)
~/dotfiles/scripts/sync_bookmarks.sh

# Add to your theme switcher or dotfiles link script for automatic sync
```

## Yazi Bookmarks (Separate System)

Yazi doesn't use system bookmarks. Instead, it has its own bookmark system:

**File**: `~/.config/yazi/yazi.toml`

```toml
[opener]
# Yazi uses 'g' keybindings for jumps

# Add custom bookmarks via keymap.toml
```

**Quick jumps in Yazi**:
- `g` + `h` = Home
- `g` + `d` = Downloads (if configured)
- `g` + `c` = Config directory

You can add custom shortcuts in `~/.config/yazi/keymap.toml`.

## Terminal File Managers

### Ranger
**File**: `~/.config/ranger/bookmarks`

Format:
```
d:/home/stephen/Downloads
p:/home/stephen/projects
```

### LF
**File**: `~/.config/lf/lfrc`

Add bookmark commands:
```
map gd cd ~/Downloads
map gp cd ~/projects
```

## Dotfiles Management

Add to your dotfiles:

```bash
dotfiles/
├── .config/
│   ├── gtk-3.0/
│   │   └── bookmarks           # GTK bookmarks (Thunar, most apps)
│   ├── user-dirs.dirs          # XDG standard directories
│   └── yazi/
│       └── keymap.toml         # Yazi custom shortcuts
└── scripts/
    └── sync_bookmarks.sh       # Optional: GTK ↔ Qt sync
```

## Best Practices

### 1. Keep GTK Bookmarks in Dotfiles ✅
Since most apps use GTK, this is your primary bookmark source.

```bash
# Already done in your dotfiles!
~/dotfiles/.config/gtk-3.0/bookmarks
```

### 2. Use Absolute Paths
Always use full paths with `file://` prefix:
```
file:///home/stephen/projects Projects
```

### 3. Add Descriptions
Makes bookmarks easier to identify:
```
file:///home/stephen/projects/theme-switcher Theme Switcher
file:///mnt/backup Backup Drive
```

### 4. Group Related Bookmarks
Use comments (GTK bookmarks support `#` comments):
```
# Development
file:///home/stephen/projects Projects
file:///home/stephen/dotfiles Dotfiles

# Media
file:///home/stephen/Pictures Pictures
file:///home/stephen/Videos Videos
```

### 5. Keep XDG Dirs Updated
Edit `~/.config/user-dirs.dirs` if you change standard folder locations.

## Testing Bookmark Sync

```bash
# Check GTK bookmarks
cat ~/.config/gtk-3.0/bookmarks

# Check Qt bookmarks (if you use Dolphin)
cat ~/.local/share/user-places.xbel

# Test in Thunar
thunar
# Look at sidebar - your bookmarks should appear

# Test in file dialog
firefox
# File > Save As - bookmarks appear in left sidebar
```

## Troubleshooting

### Bookmarks don't appear in Thunar
1. Check file exists: `ls -la ~/.config/gtk-3.0/bookmarks`
2. Check it's symlinked: `readlink ~/.config/gtk-3.0/bookmarks`
3. Verify format: Must start with `file://`
4. Restart Thunar: `killall thunar && thunar`

### Bookmarks don't appear in file dialogs
1. Check GTK version: Some older apps use GTK2
2. Try GTK2 bookmarks: `~/.gtk-bookmarks` (legacy)
3. Verify paths exist: Bookmarks to non-existent paths won't show

### Different bookmarks in Qt apps
Qt apps use `~/.local/share/user-places.xbel`. Use the sync script to keep them in sync.

## Current Setup (Your Dotfiles)

Your current bookmarks (`~/.config/gtk-3.0/bookmarks`):
```
file:///home/stephen/Downloads Downloads
file:///home/stephen/Documents Documents
file:///home/stephen/Pictures Pictures
file:///home/stephen/Videos Videos
file:///home/stephen/projects Projects
file:///home/stephen/dotfiles Dotfiles
file:///tmp Temp
```

These work in:
- ✅ Thunar (your file manager)
- ✅ Firefox/Zen save dialogs
- ✅ Most Linux applications
- ✅ Screenshot tools
- ✅ Any GTK file chooser

## Summary

**For your setup (Thunar + GTK apps):**
- ✅ **Primary bookmarks**: `~/.config/gtk-3.0/bookmarks` (already in dotfiles)
- ✅ **Standard folders**: `~/.config/user-dirs.dirs` (universal)
- ✅ **Automatically synced**: All GTK apps share bookmarks
- ⚠️  **Qt apps**: Would need sync script (not needed if you don't use Dolphin)
- ⚠️  **Yazi/Ranger**: Separate systems, manual config needed

**You're 90% done!** Since you're using Thunar and most Linux apps use GTK, your bookmarks are already synced across most programs.

## Quick Reference Commands

```bash
# Add a bookmark
echo "file:///path/to/folder Label" >> ~/.config/gtk-3.0/bookmarks

# Edit bookmarks
nvim ~/.config/gtk-3.0/bookmarks

# Add bookmark via Thunar
# Navigate to folder, then Ctrl+D

# Verify bookmarks
cat ~/.config/gtk-3.0/bookmarks

# Test in file dialog
thunar  # Check sidebar
```
