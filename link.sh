#!/bin/bash

# ============================================================================
# DOTFILES LINKING SCRIPT - Safe Stow Management
# ============================================================================
# This script safely links dotfiles using GNU Stow without destroying existing
# configs. It handles auto-generated files and checks for conflicts first.
# ============================================================================

DOTFILES_DIR="$HOME/dotfiles"

# Change to the dotfiles directory
cd "$DOTFILES_DIR" || { echo "❌ Dotfiles directory not found!"; exit 1; }

echo "🔍 Checking for conflicts..."

# ============================================================================
# Step 1: Handle Known Auto-Generated Files
# ============================================================================
# Some programs auto-generate default configs on first run. We need to remove
# these BEFORE stowing, or they'll block our symlinks.

# Hyprland creates default config on first run
if [ -f "$HOME/.config/hypr/hyprland.conf" ] && [ ! -L "$HOME/.config/hypr/hyprland.conf" ]; then
    echo "  → Removing auto-generated Hyprland config"
    rm -f "$HOME/.config/hypr/hyprland.conf"
fi

# Add other known auto-generated files here as you discover them
# Example:
# if [ -f "$HOME/.config/someapp/config" ] && [ ! -L "$HOME/.config/someapp/config" ]; then
#     echo "  → Removing auto-generated someapp config"
#     rm -f "$HOME/.config/someapp/config"
# fi

# Explicitly remove .git symlink if it somehow got linked
if [ -L "$HOME/.git" ]; then
    rm "$HOME/.git"
    echo "  → Removed .git symlink from home directory"
fi

# ============================================================================
# Step 2: Dry-Run to Check for Remaining Conflicts
# ============================================================================
echo ""
echo "🧪 Running dry-run to check for conflicts..."

# Run dry-run and capture output
stow --simulate --restow -t ~ . > /tmp/stow_dryrun.log 2>&1

# Check for real conflicts (not just simulation mode warning)
if grep -q "cannot stow\|existing target\|conflicts" /tmp/stow_dryrun.log; then
    echo ""
    echo "⚠️  Conflicts detected! See details below:"
    grep -v "WARNING: in simulation mode" /tmp/stow_dryrun.log
    echo ""
    echo "Options to resolve:"
    echo "  1. Manually remove/backup the conflicting files listed above"
    echo "  2. Run: cd ~/dotfiles && stow --adopt -t ~ ."
    echo "     (This moves existing files INTO your dotfiles repo - review with git diff after)"
    echo "  3. Add the conflicting files to the auto-generated files section above"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborted. Please resolve conflicts first."
        exit 1
    fi
else
    echo "✓ No conflicts detected"
fi

# ============================================================================
# Step 3: Actually Link with Stow (Safe Restow)
# ============================================================================
echo ""
echo "🔗 Linking dotfiles with stow..."

# Use --restow instead of unstow + stow
# This safely replaces existing symlinks without removing them first
if ! stow --restow -t ~ . 2>&1 | tee /tmp/stow_output.log; then
    echo ""
    echo "❌ ERROR: Stow failed! Check /tmp/stow_output.log for details."
    echo ""
    echo "Common issues:"
    echo "  - A program created a real file where a symlink should be"
    echo "  - Try running the script again (it may have cleaned up the blocker)"
    echo "  - Or use: stow --adopt -t ~ . (then review with git diff)"
    exit 1
fi

echo "✓ Dotfiles linked successfully!"

# ============================================================================
# Step 4: Fix Permissions & Reload Configs
# ============================================================================
echo ""
echo "🔧 Fixing permissions and reloading configs..."

# Fix SSH directory permissions (required by SSH)
if [ -d "$HOME/.ssh" ]; then
    chmod 700 "$HOME/.ssh"
    [ -f "$HOME/.ssh/config" ] && chmod 600 "$HOME/.ssh/config"
    [ -f "$HOME/.ssh/known_hosts" ] && chmod 600 "$HOME/.ssh/known_hosts"
    echo "  ✓ SSH permissions fixed (700 for dir, 600 for files)"
fi

# Reload tmux config if tmux is running
if command -v tmux &> /dev/null && tmux list-sessions &> /dev/null 2>&1; then
    tmux source-file ~/.tmux.conf 2>/dev/null && echo "  ✓ Tmux config reloaded"
fi

# Reload Hyprland if running
if pgrep -x Hyprland > /dev/null; then
    hyprctl reload > /dev/null 2>&1 && echo "  ✓ Hyprland config reloaded"
fi

echo ""
echo "🎉 Done! Your dotfiles are linked and ready."
