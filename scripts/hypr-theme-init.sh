#!/usr/bin/env bash

# Hyprland Theme Initialization Script
# Loads the last selected wallpaper on login
# Note: HyprPanel uses its saved config automatically, no need to apply theme at startup

set -e

# Configuration
CURRENT_THEME_FILE="$HOME/.config/current-theme"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
THEMES_DIR="$DOTFILES_DIR/.config/theme-switcher/themes"

# Logging
LOG_FILE="/tmp/hypr-theme-init.log"
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [hypr-theme-init] $1" | tee -a "$LOG_FILE"
}

# Load a random wallpaper from the current theme
load_random_wallpaper() {
    if [ ! -f "$CURRENT_THEME_FILE" ]; then
        log "No current theme set, skipping wallpaper"
        return 0
    fi

    local theme_name=$(cat "$CURRENT_THEME_FILE")
    log "Loading random wallpaper from theme: $theme_name"

    if [ -x "$SCRIPT_DIR/random-wallpaper" ]; then
        "$SCRIPT_DIR/random-wallpaper" 2>&1 | while read line; do log "$line"; done
    else
        log "WARNING: random-wallpaper script not found or not executable"
    fi
}

# Main execution
main() {
    log "=== Starting Hyprland theme initialization ==="
    log "Logs are being written to: $LOG_FILE"

    # Load random wallpaper (HyprPanel will use its saved config automatically)
    load_random_wallpaper

    log "=== Theme initialization complete ==="
}

main "$@"
