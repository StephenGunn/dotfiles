# Dotfiles

This repo is my home base for my Arch Linux development environment dotfiles. I am using Stow to make sure I am version controlling only the files I want.

## Quick Start

1. Clone this repository to your home directory:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Install essential packages:
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
  - lazygit (git TUI)

## Utility Scripts

The `scripts/` directory contains several helpful scripts:

- **install.sh** - Installs all required packages (pacman and AUR)
- **config.sh** - Sets up configuration for various tools
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

## Links & References

- [GNU Stow](https://www.gnu.org/software/stow)
- [Managing dotfiles with stow](https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html)
- [Original Inspiration](https://www.youtube.com/watch?v=y6XCebnB9gs)
