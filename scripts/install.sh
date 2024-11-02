#!/bin/bash

# Define an array of core programs to install
PROGRAMS=(
    "alacritty"
    "neovim"
    "tmux"
    "waybar"
    "wezterm"
    "zsh"
    "kitty"
    "fzf"
    "lazygit"
    "yazi"
    "fish"
    "fisher"
    "starship"
    "xclip"
    "wl-clipboard"
    "xsel"
    "discord"
    "fastfetch"
    "borg"
    "grim"
    "hyprpaper"
    "hypridle"
    "inotify-tools"
    # Add any other core programs you need
)

# Additional essential packages to install with pacman
ADDITIONAL_PACMAN_PACKAGES=(
    "pipewire"
    "libgtop"
    "bluez"
    "bluez-utils"
    "btop"
    "networkmanager"
    "dart-sass"
    "wl-clipboard"
    "brightnessctl"
    "swww"
    "python"
    "gnome-bluetooth-3.0"
    "pacman-contrib"
    "power-profiles-daemon"
    "gvfs"
)

# AUR packages to install with yay
AUR_PACKAGES=(
    "grimblast-git"
    "gpu-screen-recorder"
    "hyprpicker"
    "matugen-bin"
    "python-gpustat"
    "aylurs-gtk-shell-git"
)

# Update the package database and upgrade the system
echo "Updating package database and upgrading the system..."
sudo pacman -Syu --noconfirm

# Install core programs
echo "Installing core programs..."
for program in "${PROGRAMS[@]}"; do
    if pacman -Qi $program &>/dev/null; then
        echo "$program is already installed."
    else
        echo "Installing $program..."
        sudo pacman -S $program --noconfirm
    fi
done

# Install additional essential packages
echo "Installing additional essential packages..."
for package in "${ADDITIONAL_PACMAN_PACKAGES[@]}"; do
    if pacman -Qi $package &>/dev/null; then
        echo "$package is already installed."
    else
        echo "Installing $package..."
        sudo pacman -S $package --noconfirm
    fi
done

# Install AUR packages using yay
echo "Installing AUR packages..."
for aur_package in "${AUR_PACKAGES[@]}"; do
    if yay -Qi $aur_package &>/dev/null; then
        echo "$aur_package is already installed."
    else
        echo "Installing $aur_package..."
        yay -S $aur_package --noconfirm
    fi
done

# Install HyprPanel to ~/.local/share and link to ~/.config/ags
echo "Installing HyprPanel..."
if [ ! -d "$HOME/.local/share/HyprPanel" ]; then
    git clone https://github.com/Jas-SinghFSU/HyprPanel.git "$HOME/.local/share/HyprPanel"
    ln -s "$HOME/.local/share/HyprPanel" "$HOME/.config/ags"
    echo "HyprPanel installed successfully!"
else
    echo "HyprPanel is already installed."
fi

# Install Bun
echo "Installing Bun..."
if [ ! -d "$HOME/.bun" ]; then
    curl -fsSL https://bun.sh/install | bash
    echo 'export PATH="$HOME/.bun/bin:$PATH"' >> "$HOME/.bashrc" # or ~/.zshrc if using Zsh
    source "$HOME/.bashrc" # or source ~/.zshrc
    echo "Bun installed successfully!"
else
    echo "Bun is already installed."
fi

echo "All programs installed successfully!"
