#!/bin/bash

# Define an array of programs to install
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
    # Add any other programs you need
)

# Update the package database and upgrade the system
echo "Updating package database and upgrading the system..."
sudo pacman -Syu --noconfirm

# Loop through the array and install each program
for program in "${PROGRAMS[@]}"; do
    if pacman -Qi $program &>/dev/null; then
        echo "$program is already installed."
    else
        echo "Installing $program..."
        sudo pacman -S $program --noconfirm
    fi
done

echo "All programs installed successfully!"

