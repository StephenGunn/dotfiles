#!/bin/bash

# Define the dotfiles repo location
DOTFILES_DIR="$HOME/dotfiles"

# Change to the dotfiles directory
cd "$DOTFILES_DIR" || { echo "Dotfiles directory not found!"; exit 1; }

# Run stow command to link all directories
stow -t ~ .

echo "Dotfiles have been linked!"

