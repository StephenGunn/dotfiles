#!/bin/bash

# Directory where your dotfiles are located
DOTFILES_DIR="$HOME/dotfiles"

# Helper function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Install Fish Plugin Manager (Fisher) if Fish is installed
install_fisher() {
    if command_exists fish; then
        # Check if Fisher is installed, if not, install it
        if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
            echo "Installing Fisher plugin manager for Fish..."
            curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
        else
            echo "Fisher is already installed, skipping..."
        fi

        # Install Catppuccin Mocha theme for Fish
        if ! fisher list | grep -q "catppuccin/fish@mocha"; then
            echo "Installing Catppuccin Mocha theme for Fish..."
            fisher install catppuccin/fish@mocha
        else
            echo "Catppuccin Mocha theme is already installed, skipping..."
        fi
    else
        echo "Fish shell is not installed, skipping Fisher and theme installation."
    fi
}

# Function to install any other plugin managers or necessary dependencies
install_other_tools() {
    echo "Installing other tools if necessary..."

    # Example: Check and install tools like tmux plugin manager (TPM)
    if command_exists tmux; then
        if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
            echo "Installing Tmux Plugin Manager (TPM)..."
            git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        else
            echo "Tmux Plugin Manager is already installed, skipping..."
        fi
    else
        echo "Tmux is not installed, skipping TPM installation."
    fi

    # Add other tools installation as needed
}

# Run functions to install necessary tools and configurations
install_fisher
install_other_tools

echo "Installations and configurations completed!"

