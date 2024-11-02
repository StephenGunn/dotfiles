#!/bin/bash

# Define the dotfiles repo location
DOTFILES_DIR="$HOME/dotfiles"

# Change to the dotfiles directory
cd "$DOTFILES_DIR" || { echo "Dotfiles directory not found!"; exit 1; }

# check to see if hyprland.conf already exists (will be default) - if it does, and isn't a symlink, delete it and link our custom conf
HYPERLAND_CONFIG="$HOME/.config/hypr/hyprland.conf"

if [ -e "$HYPRLAND_CONFIG" ] && [ ! -L "$HYPRLAND_CONFIG" ]; then
	echo "removing default hyprland config"
	rm "$HYPRLAND_CONFIG"
fi

# Unstow all existing links to clean up old or accidental links
stow -D -t ~ .

# Explicitly remove the .git folder in case it gets linked
if [ -L "$HOME/.git" ]; then
    rm "$HOME/.git"
    echo "Unlinked .git from home directory"
fi

# Run stow command to link all directories
stow -t ~ .

echo "Dotfiles have been unlinked and re-linked!"
