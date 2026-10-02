# Dotfiles

Arch Linux development environment managed with [GNU Stow](https://www.gnu.org/software/stow). One repo, multiple machines, unified theming.

## Quick Start

1. Clone this repository to your home directory:
   ```bash
   git clone https://github.com/StephenGunn/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Clone the theme-switcher (separate project):
   ```bash
   git clone https://github.com/StephenGunn/theme-switcher.git ~/projects/theme-switcher
   ```

3. Run setup:
   ```bash
   ./scripts/install.sh                  # Install packages (core + host-specific)
   ./link.sh                             # Create symlinks + host configs + theme-switch
   ./scripts/install_nerd_fonts.sh       # Install Nerd Fonts
   ./scripts/restore_systemd_services.sh # Restore systemd user services
   ./scripts/configure_hyprpanel.sh      # Setup HyprPanel
   ```

## Requirements

- Git
- GNU Stow

## Configurations

### Window Manager & Desktop
- **Hyprland** — Wayland compositor (Lua config)
- **HyprPanel** — AGS-based desktop panel (primary)
- **QuickShell** — Qt6 shell components
- **Waybar** — Status bar (secondary/fallback)
- **Rofi** — Application launcher + custom menus
- **Dunst** — Notification daemon
- **Hyprlock / Hypridle** — Lock screen & idle management

### Terminal & Shell
- **Fish** — Primary shell with vi keybindings, custom aliases, Starship prompt
- **Ghostty** — Default terminal emulator
- **Alacritty, Kitty, Wezterm** — Alternative terminals
- **Tmux** — Terminal multiplexer

### Development Tools
- **Neovim** — Primary editor (lazy.nvim, LSP)
- **Lazygit** — Git TUI (`gg` alias)
- **Posting** — HTTP client TUI

### File Management
- **Yazi** — TUI file manager
- **Thunar** — GTK file manager (source of truth for bookmarks)

### Utilities
- **Zoxide** — Smarter `cd`
- **fzf** — Fuzzy finder
- **Fastfetch** — System info
- **Looking Glass** — GPU passthrough display client
- **OBS Studio** — Streaming/recording
- **Waypaper** — Wallpaper manager

## Scripts

The `scripts/` directory contains setup and utility scripts:

### Setup & Installation
| Script | Description |
|--------|-------------|
| `install.sh` | Install packages from `packages/core.md` + `packages/<hostname>.md` |
| `install_nerd_fonts.sh` | Install Nerd Fonts for terminal icons |
| `configure_hyprpanel.sh` | Configure HyprPanel and set up autostart |
| `configure_sddm.sh` | Configure SDDM display manager |
| `setup_nvidia.sh` | NVIDIA GPU setup |
| `set_default_shell.sh` | Set default shell to Fish |
| `configure_system_defaults.sh` | Set XDG default applications |
| `clone_projects.sh` | Clone common project repos |

### Systemd Services
| Script | Description |
|--------|-------------|
| `backup_systemd_services.sh` | Back up enabled user services |
| `restore_systemd_services.sh` | Restore user services from backup |
| `restore_system_services.sh` | Restore system-level services |
| `setup_systemd_backup_cron.sh` | Set up weekly automatic service backups |

### Rofi Menus
| Script | Description |
|--------|-------------|
| `rofi-audio-sink.sh` | Audio output device picker |
| `rofi-audio-source.sh` | Audio input device picker |
| `rofi-brightness.sh` | Display brightness control |
| `rofi-dev.sh` | Development project launcher |
| `rofi-vm.sh` | Virtual machine launcher |
| `rofi-streaming.sh` | Streaming mode controls |

### Streaming & Display
| Script | Description |
|--------|-------------|
| `streaming-mode.sh` | Toggle streaming mode |
| `streaming-scratchpad-daemon.sh` | Streaming scratchpad management |
| `streaming-widget-daemon.sh` | Streaming widget overlay |
| `display-toggle.sh` | Toggle displays on/off |
| `camera-control.sh` | Webcam controls |
| `webcam-expand.sh` | Expand webcam preview |
| `screenshot-save.sh` | Screenshot utility |

### Other Utilities
| Script | Description |
|--------|-------------|
| `startup.sh` | Hyprland autostart script |
| `config.sh` | General tool configuration |
| `sync_bookmarks.sh` | Sync GTK bookmarks → Qt (one-way) |
| `gpu-monitor.sh` | GPU usage monitor |
| `hypr-theme-init.sh` | Initialize Hyprland theme on boot |
| `cmatrix-screensaver.sh` | CMatrix screensaver |

## Multi-Machine Support

This repo supports multiple machines using hostname-based configs. A single branch serves all hosts.

### Current Hosts

| Hostname | Machine | Display |
|----------|---------|---------|
| `jovian` | Desktop | Triple monitor (vertical + main + side) |
| `titan` | HP OMEN MAX 16" laptop | 2560x1600@240 |
| `surfarch` | Surface Pro 8 tablet | 2880x1920@120 |
| `streamcentre` | Streaming box | 1080p HDMI |

### How It Works

- **Hyprland**: `hosts/init.lua` loads `hosts/<hostname>.lua` at runtime (monitors, workspaces, host-specific settings)
- **Hypridle**: `link.sh` symlinks `hosts/hypridle-<hostname>.conf` → `hypridle.conf`
- **Packages**: `install.sh` reads `packages/core.md` (all machines) + `packages/<hostname>.md` (machine-specific)
- **Colors**: `conf/colors.lua` loads `colors_override.lua` (written by theme-switch), falls back to Catppuccin Mocha

### Adding a New Machine

1. **Create host Hyprland config**:
   ```bash
   cp .config/hypr/hosts/jovian.lua .config/hypr/hosts/<hostname>.lua
   # Edit monitors and workspaces for your hardware
   ```

2. **Create host hypridle config** (optional):
   ```bash
   cp .config/hypr/hosts/hypridle-jovian.conf .config/hypr/hosts/hypridle-<hostname>.conf
   ```

3. **Create host packages** (optional):
   ```bash
   cp packages/jovian.md packages/<hostname>.md
   ```

4. **Run setup**:
   ```bash
   ./scripts/install.sh   # Installs core.md + <hostname>.md
   ./link.sh              # Links dotfiles + host-specific configs
   ```

## Structure

```
dotfiles/
├── .config/
│   ├── hypr/
│   │   ├── hyprland.lua          # Main Hyprland config (Lua)
│   │   ├── conf/                 # Modular config
│   │   │   ├── appearance.lua
│   │   │   ├── autostart.lua
│   │   │   ├── colors.lua        # Color palette (loads override)
│   │   │   ├── input.lua
│   │   │   ├── keybinds.lua
│   │   │   ├── streaming.lua
│   │   │   └── windowrules.lua
│   │   ├── hosts/                # Per-machine configs
│   │   │   ├── init.lua          # Hostname dispatcher
│   │   │   ├── jovian.lua
│   │   │   ├── titan.lua
│   │   │   ├── surfarch.lua
│   │   │   └── streamcentre.lua
│   │   ├── colors_override.lua   # Written by theme-switch
│   │   ├── hyprlock.conf
│   │   ├── hypridle.conf         # Symlink → hosts/hypridle-<host>.conf
│   │   └── pyprland.toml
│   ├── fish/                     # Shell config
│   ├── nvim/                     # Neovim config
│   ├── ghostty/                  # Default terminal
│   ├── hyprpanel/                # Desktop panel
│   ├── quickshell/               # Qt6 shell
│   ├── rofi/                     # Launcher + menus
│   ├── looking-glass/            # GPU passthrough client
│   ├── obs-studio/               # Streaming/recording
│   ├── streaming/                # Streaming mode config
│   └── ...                       # alacritty, kitty, wezterm, dunst, etc.
├── packages/
│   ├── core.md                   # Shared packages (all machines)
│   ├── jovian.md
│   ├── titan.md
│   ├── surfarch.md
│   └── streamcentre.md
├── scripts/                      # Setup & utility scripts
├── docs/                         # Streaming, dev sessions, diagnostics
├── wallpapers/                   # Wallpaper collection
├── link.sh                       # Stow linking + host config setup
└── grub/                         # GRUB config
```

## Theme Switcher

Unified theming via a [separate theme-switcher project](https://github.com/StephenGunn/theme-switcher).

### Usage
- **Keybinding**: `Super + T` — opens theme selector
- **Command**: `theme-switch` or `theme-switch <theme-name>`

### What Gets Themed
Ghostty, Neovim, Hyprland, HyprPanel, Rofi, Thunar (GTK), Yazi, Starship, Dunst, and wallpapers.

### How It Works
Theme-switch writes `colors_override.lua` which is loaded by `conf/colors.lua` at Hyprland reload. Each theme provides color definitions, terminal themes, panel configs, and wallpapers. See the [theme-switcher repo](https://github.com/StephenGunn/theme-switcher) for full documentation.

## Bookmarks

**Source of truth**: Thunar / GTK bookmarks (`~/.config/gtk-3.0/bookmarks`)

- Add in Thunar with `Ctrl+D`, or edit the file directly
- Sync to Qt apps: `./scripts/sync_bookmarks.sh` (one-way)
- Automatically used by Thunar, Firefox/Zen file dialogs, and GTK file choosers

## Documentation

- `CLAUDE.md` — Instructions for Claude Code
- `SYSTEM_DEFAULTS.md` — Default applications and XDG config
- `BOOKMARKS_SYNC.md` / `GTK_BOOKMARKS.md` — Bookmark sync documentation
- `docs/streaming-mode.md` — Streaming mode setup and usage
- `docs/streaming-keybinds.md` — Streaming keybinds reference
- `docs/DEV_SESSIONS.md` — Dev session management

## Links

- [GNU Stow](https://www.gnu.org/software/stow)
- [Managing dotfiles with stow](https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html)
