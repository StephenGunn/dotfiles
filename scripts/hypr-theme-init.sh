#!/usr/bin/env bash

# Hyprland Theme Initialization Script
# Loads the last selected wallpaper and applies quickshell colors on login

set -e

# Configuration
CURRENT_THEME_FILE="$HOME/.config/current-theme"
THEME_SWITCHER_DIR="$HOME/projects/theme-switcher"
RANDOM_WALLPAPER_SCRIPT="$THEME_SWITCHER_DIR/scripts/random-wallpaper"
THEMES_DIR="$THEME_SWITCHER_DIR/themes"
TEMPLATES_DIR="$THEME_SWITCHER_DIR/templates"

# Logging
LOG_FILE="/tmp/hypr-theme-init.log"
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [hypr-theme-init] $1" | tee -a "$LOG_FILE"
}

# Apply quickshell colors from theme config
apply_quickshell_colors() {
    if [ ! -f "$CURRENT_THEME_FILE" ]; then
        log "No current theme set, skipping quickshell colors"
        return 0
    fi

    local theme_name=$(cat "$CURRENT_THEME_FILE")
    local config_file="$THEMES_DIR/$theme_name/config.json"

    if [ ! -f "$config_file" ]; then
        log "Theme config not found: $config_file"
        return 0
    fi

    local has_quickshell=$(jq -r '.apps.quickshell // empty' "$config_file")
    if [ -z "$has_quickshell" ]; then
        log "No quickshell config in theme, skipping"
        return 0
    fi

    log "Applying quickshell colors from theme: $theme_name"

    local template_file="$TEMPLATES_DIR/quickshell-colors.qml"
    if [ ! -f "$template_file" ]; then
        log "Quickshell template not found: $template_file"
        return 1
    fi

    # Extract colors from config
    local bg=$(jq -r '.apps.quickshell.colors.background' "$config_file")
    local bg_light=$(jq -r '.apps.quickshell.colors.background_light' "$config_file")
    local fg=$(jq -r '.apps.quickshell.colors.foreground' "$config_file")
    local fg_dim=$(jq -r '.apps.quickshell.colors.foreground_dim' "$config_file")
    local accent=$(jq -r '.apps.quickshell.colors.accent' "$config_file")
    local accent_bright=$(jq -r '.apps.quickshell.colors.accent_bright' "$config_file")
    local red=$(jq -r '.apps.quickshell.colors.red' "$config_file")
    local green=$(jq -r '.apps.quickshell.colors.green' "$config_file")
    local yellow=$(jq -r '.apps.quickshell.colors.yellow' "$config_file")
    local blue=$(jq -r '.apps.quickshell.colors.blue' "$config_file")
    local magenta=$(jq -r '.apps.quickshell.colors.magenta' "$config_file")
    local cyan=$(jq -r '.apps.quickshell.colors.cyan' "$config_file")
    local red_bright=$(jq -r '.apps.quickshell.colors.red_bright' "$config_file")
    local green_bright=$(jq -r '.apps.quickshell.colors.green_bright' "$config_file")
    local yellow_bright=$(jq -r '.apps.quickshell.colors.yellow_bright' "$config_file")
    local blue_bright=$(jq -r '.apps.quickshell.colors.blue_bright' "$config_file")
    local magenta_bright=$(jq -r '.apps.quickshell.colors.magenta_bright' "$config_file")
    local cyan_bright=$(jq -r '.apps.quickshell.colors.cyan_bright' "$config_file")
    local separator=$(jq -r '.apps.quickshell.colors.separator' "$config_file")
    local ws_active=$(jq -r '.apps.quickshell.colors.workspace_active' "$config_file")
    local ws_occupied=$(jq -r '.apps.quickshell.colors.workspace_occupied' "$config_file")
    local ws_empty=$(jq -r '.apps.quickshell.colors.workspace_empty' "$config_file")
    local font_family=$(jq -r '.apps.quickshell.font_family // "JetBrainsMono Nerd Font"' "$config_file")

    # Generate themed quickshell colors file
    local quickshell_colors=$(cat "$template_file" | \
        sed "s/{background}/$bg/g" | \
        sed "s/{background_light}/$bg_light/g" | \
        sed "s/{foreground_dim}/$fg_dim/g" | \
        sed "s/{foreground}/$fg/g" | \
        sed "s/{accent_bright}/$accent_bright/g" | \
        sed "s/{accent}/$accent/g" | \
        sed "s/{red_bright}/$red_bright/g" | \
        sed "s/{red}/$red/g" | \
        sed "s/{green_bright}/$green_bright/g" | \
        sed "s/{green}/$green/g" | \
        sed "s/{yellow_bright}/$yellow_bright/g" | \
        sed "s/{yellow}/$yellow/g" | \
        sed "s/{blue_bright}/$blue_bright/g" | \
        sed "s/{blue}/$blue/g" | \
        sed "s/{magenta_bright}/$magenta_bright/g" | \
        sed "s/{magenta}/$magenta/g" | \
        sed "s/{cyan_bright}/$cyan_bright/g" | \
        sed "s/{cyan}/$cyan/g" | \
        sed "s/{separator}/$separator/g" | \
        sed "s/{workspace_active}/$ws_active/g" | \
        sed "s/{workspace_occupied}/$ws_occupied/g" | \
        sed "s/{workspace_empty}/$ws_empty/g" | \
        sed "s/{font_family}/$font_family/g")

    # Write to quickshell config directory
    mkdir -p "$HOME/.config/quickshell"
    echo "$quickshell_colors" > "$HOME/.config/quickshell/Colors.qml"

    # Also update dotfiles version
    if [ -d "$HOME/dotfiles/.config/quickshell" ]; then
        echo "$quickshell_colors" > "$HOME/dotfiles/.config/quickshell/Colors.qml"
    fi

    log "Quickshell colors applied"
}

# Load a random wallpaper from the current theme
load_random_wallpaper() {
    if [ ! -f "$CURRENT_THEME_FILE" ]; then
        log "No current theme set, skipping wallpaper"
        return 0
    fi

    local theme_name=$(cat "$CURRENT_THEME_FILE")
    log "Loading random wallpaper from theme: $theme_name"

    if [ -x "$RANDOM_WALLPAPER_SCRIPT" ]; then
        "$RANDOM_WALLPAPER_SCRIPT" 2>&1 | while read line; do log "$line"; done
    else
        log "WARNING: random-wallpaper script not found at $RANDOM_WALLPAPER_SCRIPT"
    fi
}

# Main execution
main() {
    log "=== Starting Hyprland theme initialization ==="
    log "Logs are being written to: $LOG_FILE"

    # Apply quickshell colors before it starts
    apply_quickshell_colors

    # Load random wallpaper
    load_random_wallpaper

    log "=== Theme initialization complete ==="
}

main "$@"
