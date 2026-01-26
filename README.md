# Dotfiles

This repo is my home base for my Arch Linux development environment dotfiles. I am using Stow to make sure I am version controlling only the files I want.

## Quick Start

1. Clone this repository to your home directory:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Clone the theme-switcher (separate project):
   ```bash
   git clone https://github.com/StephenGunn/theme-switcher.git ~/projects/theme-switcher
   ln -sf ~/projects/theme-switcher/scripts/theme-switch ~/.local/bin/theme-switch
   ```

3. Install essential packages:
   ```bash
   # Install base packages
   ./scripts/install.sh

   # Install configuration files
   ./link.sh

   # Install Nerd Fonts
   ./scripts/install_nerd_fonts.sh

   # Restore systemd services
   ./scripts/restore_systemd_services.sh

   # Configure HyprPanel
   ./scripts/configure_hyprpanel.sh
   ```

## Requirements

- Git
- Stow

## Configurations Included

- **Shells**
  - fish (primary shell with plugins)
  - zsh (with oh-my-zsh)
  
- **Terminal Emulators**
  - alacritty
  - kitty
  - wezterm
  - ghostty
  
- **Window Manager & UI**
  - hyprland
  - waybar
  - hyprpanel (AGS-based desktop UI)
  
- **Development Tools**
  - neovim
  - tmux
  - git
  
- **Utilities**
  - rofi/wofi (application launchers)
  - fzf (fuzzy finder)
  - starship (prompt)
  - zoxide (smarter cd)
  - yazi (file manager)
  - thunar (GTK file manager - **source of truth for bookmarks**)
  - lazygit (git TUI)

## Utility Scripts

The `scripts/` directory contains several helpful scripts:

- **install.sh** - Installs all required packages (pacman and AUR)
- **config.sh** - Sets up configuration for various tools
- **configure_system_defaults.sh** - Sets up XDG default applications (file manager, browser, editor)
- **sync_bookmarks.sh** - Syncs GTK bookmarks (Thunar) to Qt format (one-way)
- **backup_systemd_services.sh** - Backs up enabled systemd user services
- **restore_systemd_services.sh** - Restores systemd user services
- **setup_systemd_backup_cron.sh** - Sets up weekly automatic backups of systemd services
- **install_nerd_fonts.sh** - Installs Nerd Fonts needed for proper icons
- **configure_hyprpanel.sh** - Configures HyprPanel and sets up autostart

## How to Use Stow

Stow is used to create symlinks from this repository to your home directory:

```bash
# Use the provided script (recommended)
./link.sh

# Or manually with stow
stow -t ~ .
```

## Structure

Each application's configuration is stored in its proper XDG directory structure under `.config/`:

```
dotfiles/
├── .config/
│   ├── alacritty/
│   ├── fish/
│   ├── hypr/
│   ├── kitty/
│   ├── neovim/
│   ├── systemd/
│   ├── tmux/
│   ├── waybar/
│   └── wezterm/
├── .ssh/
│   └── config
├── scripts/
│   ├── install.sh
│   ├── config.sh
│   ├── backup_systemd_services.sh
│   ├── restore_systemd_services.sh
│   ├── setup_systemd_backup_cron.sh
│   ├── install_nerd_fonts.sh
│   └── configure_hyprpanel.sh
└── link.sh
```

## Maintaining the Repository

- To backup your current systemd services: `./scripts/backup_systemd_services.sh`
- To set up automatic weekly backups: `./scripts/setup_systemd_backup_cron.sh`
- To update package lists after installing new software: edit `scripts/install.sh`
- After making changes, commit and push to your repository

## Theme Switcher Integration

This dotfiles repo integrates with a **separate theme-switcher project** for unified theming.

### Setup
```bash
# Clone theme-switcher (separate git repo)
git clone https://github.com/StephenGunn/theme-switcher.git ~/projects/theme-switcher

# Create symlink for easy access
ln -sf ~/projects/theme-switcher/scripts/theme-switch ~/.local/bin/theme-switch
```

### Usage
- **Keybinding**: `Super + T` - Opens theme selector
- **Command**: `theme-switch` - Opens theme selector
- **Direct**: `theme-switch <theme-name>` - Switch directly

### Available Themes
1. Gruvbox Dark
2. Catppuccin Mocha
3. Nord
4. Kanagawa Dark
5. Everforest
6. Tokyo Night

### What Gets Themed
- Ghostty (terminal) - Custom theme files
- Neovim (editor) - Native colorschemes (live reload)
- Hyprland (window manager) - Color scheme files
- HyprPanel (desktop panel) - Complete theme files
- Rofi (launcher) - .rasi theme files
- Thunar (file manager) - GTK themes
- Yazi (TUI file manager) - Flavor system
- Starship (prompt) - Pywal-generated colors
- Dunst (notifications) - Pywal-generated config
- Wallpapers - Random selection with smooth transitions (swww)

### Adding New Themes
Each theme needs the following files in `~/projects/theme-switcher/themes/<theme-name>/`:
- `config.json` - Theme configuration
- `hyprpanel.json` - HyprPanel colors (simplified 20-line or full 375-line format)
- `colors.json` - Pywal color palette (16 colors)
- `<theme-name>.conf` - Hyprland color definitions
- `<theme-name>.rasi` - Rofi theme
- `wallpapers/` - Directory with wallpaper images
- Custom Ghostty theme in `~/.config/ghostty/themes/<ThemeName>`

**HyprPanel Theme Format:**
- Simplified (20 keys): Basic colors, HyprPanel auto-fills the rest
- Complete (375 keys): Full control over every UI element
- Both work! Simplified is easier to maintain.

### More Info
See the [theme-switcher repository](https://github.com/StephenGunn/theme-switcher) for documentation.

## Bookmarks & File Dialogs

**Source of Truth: Thunar (GTK Bookmarks)**

- **Primary file**: `~/.config/gtk-3.0/bookmarks`
- **Sync direction**: GTK → Qt (one-way, optional)
- **Used by**: Thunar, Firefox file dialogs, most Linux apps

### Managing Bookmarks

1. **In Thunar**: Navigate to folder, press `Ctrl+D`
2. **Edit directly**: `nvim ~/.config/gtk-3.0/bookmarks`
3. **Sync to Qt apps** (optional): `./scripts/sync_bookmarks.sh`

Bookmarks automatically appear in:
- ✅ Thunar sidebar
- ✅ Firefox/Zen save dialogs
- ✅ Most application file dialogs
- ✅ Any GTK file chooser

See `BOOKMARKS_SYNC.md` for detailed documentation.

## Documentation

- **SYSTEM_DEFAULTS.md** - Default applications and XDG configuration
- **BOOKMARKS_SYNC.md** - How bookmarks work across programs
- **GTK_BOOKMARKS.md** - GTK bookmarks and file dialog configuration
- **SETUP_COMPLETE.md** - Recent setup summary and installation steps
- **CLAUDE.md** - Instructions for Claude Code when working with this repo

## Links & References

- [GNU Stow](https://www.gnu.org/software/stow)
- [Managing dotfiles with stow](https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html)
- [Original Inspiration](https://www.youtube.com/watch?v=y6XCebnB9gs)
