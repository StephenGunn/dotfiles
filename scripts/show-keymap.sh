#!/bin/bash
# Display QMK keymap in a floating window with current theme colors

KEYMAP_SOURCE="$HOME/qmk/keymap.svg"
KEYMAP_THEMED="/tmp/keymap-themed.svg"
CURRENT_THEME_FILE="$HOME/.config/current-theme"
THEME_SWITCHER_DIR="$HOME/projects/theme-switcher"

# Default colors (from original SVG - light theme)
DEFAULT_BG="#f6f8fa"
DEFAULT_TEXT="#24292e"
DEFAULT_STROKE="#c9cccf"
DEFAULT_COMBO="#cdf"
DEFAULT_HELD="#fdd"
DEFAULT_LABEL_STROKE="white"
DEFAULT_TRANS="#7b7e81"
DEFAULT_DENDRON="gray"

# Get theme colors
get_theme_colors() {
    if [[ ! -f "$CURRENT_THEME_FILE" ]]; then
        return 1
    fi

    local theme_name=$(cat "$CURRENT_THEME_FILE")
    local config_file="$THEME_SWITCHER_DIR/themes/$theme_name/config.json"

    if [[ ! -f "$config_file" ]]; then
        return 1
    fi

    # Extract quickshell colors (they have the full palette we need)
    BG=$(jq -r '.apps.quickshell.colors.background // empty' "$config_file")
    BG_LIGHT=$(jq -r '.apps.quickshell.colors.background_light // empty' "$config_file")
    FG=$(jq -r '.apps.quickshell.colors.foreground // empty' "$config_file")
    FG_DIM=$(jq -r '.apps.quickshell.colors.foreground_dim // empty' "$config_file")
    ACCENT=$(jq -r '.apps.quickshell.colors.accent // empty' "$config_file")
    BLUE=$(jq -r '.apps.quickshell.colors.blue // empty' "$config_file")
    MAGENTA=$(jq -r '.apps.quickshell.colors.magenta // empty' "$config_file")
    RED=$(jq -r '.apps.quickshell.colors.red // empty' "$config_file")
    CYAN=$(jq -r '.apps.quickshell.colors.cyan // empty' "$config_file")

    # Check we got the essential colors
    if [[ -z "$BG" || -z "$FG" ]]; then
        return 1
    fi

    return 0
}

# Apply theme to SVG
apply_theme() {
    sed -e "s/$DEFAULT_BG/$BG_LIGHT/g" \
        -e "s/$DEFAULT_TEXT/$FG/g" \
        -e "s/$DEFAULT_STROKE/${BG_LIGHT}/g" \
        -e "s/fill: #cdf/fill: ${BLUE}40/g" \
        -e "s/fill: #fdd/fill: ${MAGENTA}40/g" \
        -e "s/stroke: white/stroke: $BG/g" \
        -e "s/$DEFAULT_TRANS/$FG_DIM/g" \
        -e "s/stroke: gray/stroke: $FG_DIM/g" \
        "$KEYMAP_SOURCE" > "$KEYMAP_THEMED"
}

# Main
if [[ ! -f "$KEYMAP_SOURCE" ]]; then
    notify-send "Keymap Viewer" "Keymap file not found: $KEYMAP_SOURCE"
    exit 1
fi

if get_theme_colors; then
    apply_theme
    imv -b "$BG" "$KEYMAP_THEMED" &
else
    # Fallback to original if no theme available
    imv "$KEYMAP_SOURCE" &
fi

# Wait for window to appear and focus it
sleep 0.1
hyprctl dispatch focuswindow class:imv
