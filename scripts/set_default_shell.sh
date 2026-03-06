#!/bin/bash

# Set fish as the default shell

set -e

FISH_PATH=$(which fish)

if [ -z "$FISH_PATH" ]; then
    echo "Error: fish is not installed"
    exit 1
fi

# Add fish to /etc/shells if not present
if ! grep -q "$FISH_PATH" /etc/shells; then
    echo "Adding fish to /etc/shells..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

# Change default shell
if [ "$SHELL" != "$FISH_PATH" ]; then
    echo "Changing default shell to fish..."
    chsh -s "$FISH_PATH"
    echo "✓ Default shell set to fish (log out and back in to apply)"
else
    echo "✓ fish is already the default shell"
fi
