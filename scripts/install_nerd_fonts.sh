#!/bin/bash

# Script to install Nerd Fonts
# Usage: ./install_nerd_fonts.sh [font_name]
# If no font name is provided, it will install the default fonts

# Default fonts to install
DEFAULT_FONTS=(
  "JetBrainsMono"
  "FiraCode"
  "Hack"
  "SymbolsOnly"
)

FONTS_DIR="$HOME/.local/share/fonts"
DOWNLOAD_DIR="/tmp/nerd-fonts"

# Create directories if they don't exist
mkdir -p "$FONTS_DIR"
mkdir -p "$DOWNLOAD_DIR"

# Function to install a specific font
install_font() {
  local font_name="$1"
  echo "Installing $font_name Nerd Font..."
  
  # Download the latest release
  echo "Downloading $font_name..."
  curl -fLo "$DOWNLOAD_DIR/$font_name.zip" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_name.zip"
  
  # Extract the font
  echo "Extracting $font_name..."
  unzip -o "$DOWNLOAD_DIR/$font_name.zip" -d "$FONTS_DIR/$font_name"
  
  echo "$font_name Nerd Font installed successfully!"
}

# Clear font cache
update_font_cache() {
  echo "Updating font cache..."
  fc-cache -f
}

# Install fonts
if [ $# -eq 0 ]; then
  # No arguments, install default fonts
  for font in "${DEFAULT_FONTS[@]}"; do
    install_font "$font"
  done
else
  # Install specified font
  install_font "$1"
fi

# Update font cache
update_font_cache

echo "Nerd Fonts installation completed!"