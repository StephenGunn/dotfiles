# SSH Clipboard Setup Documentation

## Overview

This document explains the SSH clipboard configuration for seamless copy/paste across SSH sessions using OSC 52 escape sequences.

## Your Setup

- **Local Machine**: Arch Linux with Ghostty terminal and Wayland
- **Remote Connections**: SSH to Ubuntu servers
- **Remote Access**: Mac connects via Tailscale (not traditional SSH)

## What Was Configured

### 1. Tmux OSC 52 Support (`.tmux/.tmux.conf`)

Added clipboard passthrough to allow OSC 52 sequences to work through tmux:

```tmux
set -g set-clipboard on
set -ag terminal-overrides "vte*:XT:Ms=\\E]52;c;%p2%s\\7"
set -ag terminal-overrides "xterm*:XT:Ms=\\E]52;c;%p2%s\\7"
set -ag terminal-overrides "xterm-ghostty:XT:Ms=\\E]52;c;%p2%s\\7"
```

### 2. Fish Clipboard Functions (`.config/fish/functions/clipboard.fish`)

Created easy-to-use clipboard commands that work over SSH:

| Command | Usage | Description |
|---------|-------|-------------|
| `clip` | `echo "text" \| clip` | Copy to clipboard via OSC 52 (works over SSH) |
| `clipfile <file>` | `clipfile script.sh` | Copy entire file contents |
| `copy` | `echo "text" \| copy` | Copy to Wayland clipboard (local only) |
| `paste` | `paste` | Paste from Wayland clipboard (local only) |

### 3. SSH Client Config (`.ssh/config`)

Configured SSH to preserve terminal capabilities and keep connections alive:

```ssh
Host *
    SetEnv TERM=xterm-256color
    ServerAliveInterval 60
    ServerAliveCountMax 3
    ForwardAgent yes
    AddKeysToAgent yes
```

### 4. Ghostty Terminal (`.config/ghostty/config`)

Enabled clipboard support explicitly:

```
copy-on-select=false
clipboard-read=allow
clipboard-write=allow
clipboard-paste-protection=false
```

### 5. SSH Config in Dotfiles (`.ssh/`)

- SSH config is now tracked in your dotfiles repo
- Private keys are excluded via `.ssh/.gitignore`
- Permissions are automatically fixed by `link.sh` (700 for dir, 600 for files)

## How It Works

### OSC 52 Clipboard Flow

```
Remote Server → OSC 52 Sequence → SSH Connection → Tmux → Ghostty → Wayland Clipboard
```

**OSC 52 Escape Sequence Format:**
```
\033]52;c;<base64-encoded-text>\a
```

This escape sequence travels through:
1. Your shell on the remote server
2. The SSH connection (as terminal output)
3. Tmux (if running) - passes it through
4. Ghostty terminal - intercepts and puts text in clipboard
5. Wayland clipboard system - now you can paste anywhere

### Example Usage

**On a remote Ubuntu server:**
```bash
# Copy command output
ls -la | clip

# Copy a file's contents
clipfile ~/.bashrc

# Copy some text
echo "Hello from remote server" | clip
```

**Back on your local machine:**
```bash
# Paste with Ctrl+V or:
wl-paste

# Or use the Fish function:
paste
```

## Testing

### Test 1: Local Clipboard
```bash
echo "test local" | clip
wl-paste  # Should output: test local
```

### Test 2: SSH to Ubuntu
```bash
ssh your-ubuntu-server
echo "test remote" | clip
# Exit SSH, then on local machine:
wl-paste  # Should output: test remote
```

### Test 3: Through Tmux
```bash
tmux
echo "test tmux" | clip
# Detach (Ctrl+b d) and paste - should work
```

## Troubleshooting

### Clipboard Not Working Over SSH

1. **Check TERM variable on remote:**
   ```bash
   echo $TERM  # Should be xterm-256color
   ```

2. **Test OSC 52 directly:**
   ```bash
   printf "\033]52;c;%s\a" $(echo "test" | base64)
   ```

3. **Check tmux passthrough:**
   ```bash
   tmux show-options -g | grep clipboard
   # Should show: set-clipboard on
   ```

### "clear" Command Not Found on Remote

**Solutions:**

1. **Use keyboard shortcut:** `Ctrl+L` (works in any shell)

2. **Install ncurses on remote:**
   ```bash
   sudo apt install ncurses-bin
   ```

3. **Create alias on remote:**
   ```bash
   # Add to remote ~/.bashrc or ~/.config/fish/config.fish
   alias clear='printf "\033c"'
   ```

## New Link Script Behavior

The `link.sh` script has been rewritten to be much safer:

### What Changed

**Before (DANGEROUS):**
- `stow -D` (unstow everything) → **Configs disappear!**
- `stow` (try to restow) → If this fails, you have no configs

**Now (SAFE):**
1. Remove known auto-generated files (like Hyprland defaults)
2. Run dry-run to check for conflicts
3. Prompt before continuing if conflicts exist
4. Use `stow --restow` (never removes configs unless replacing)
5. Fix permissions and reload services

### Key Features

- **No unstowing** - configs never disappear
- **Dry-run first** - checks for problems before making changes
- **Auto-handles** known programs that create default configs
- **Interactive** - prompts you if there are conflicts
- **Safe to run repeatedly** - idempotent, won't break things

### When You Add New Configs

Just run:
```bash
./link.sh
# or
dots_link
```

If a program created a file where your symlink should go:
1. The script will detect it and prompt you
2. Either manually remove the file, or
3. Add it to the "auto-generated files" section in `link.sh`

## Files Modified

| File | Changes |
|------|---------|
| `.tmux/.tmux.conf` | Added OSC 52 clipboard support |
| `.config/fish/functions/clipboard.fish` | Created (new file with clipboard functions) |
| `.ssh/config` | Created in dotfiles with SSH client settings |
| `.ssh/.gitignore` | Created (excludes private keys from git) |
| `.config/ghostty/config` | Added explicit clipboard settings |
| `link.sh` | Completely rewritten for safety |

## Additional Resources

- [OSC 52 Specification](https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Operating-System-Commands)
- [Ghostty Documentation](https://ghostty.org)
- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/)
