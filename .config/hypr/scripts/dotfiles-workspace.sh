#!/bin/bash

# Script to manage dotfiles workspace
# Opens a rofi menu with dotfiles-related actions

DOTFILES_DIR="$HOME/dotfiles"

# Function to check if dotfiles workspace is active
is_workspace_active() {
    hyprctl workspaces -j | jq -e '.[] | select(.name == "special:dotfiles")' > /dev/null
}

# Function to open dotfiles terminal
open_dotfiles_terminal() {
    # Check if workspace already exists and has a window
    if is_workspace_active; then
        # Just toggle to show it
        hyprctl dispatch togglespecialworkspace dotfiles
    else
        # Open new terminal in dotfiles directory on the special workspace (without silent to make it visible)
        hyprctl dispatch exec "[workspace special:dotfiles] ghostty --working-directory=$DOTFILES_DIR"
    fi
}

# Function to run a command in background with notifications
run_in_background() {
    local cmd="$1"
    local description="$2"
    local success_msg="$3"
    local failure_msg="$4"

    # Show notification that command is running
    notify-send "Dotfiles" "$description..." -t 2000

    # Execute command in background
    (
        cd "$DOTFILES_DIR"
        if eval "$cmd" > /tmp/dotfiles-cmd.log 2>&1; then
            notify-send "Dotfiles" "$success_msg" -t 3000
        else
            notify-send "Dotfiles" "$failure_msg" -u critical -t 5000
        fi
    ) &
}

# Rofi menu options
show_menu() {
    options=(
        "📂 Open Dotfiles Terminal"
        "🔄 Restart Quickshell"
        "👆 Restart Trackpad Gestures"
        "🔗 Run link.sh (re-link dotfiles)"
        "🔖 Sync Bookmarks"
        "💾 Backup Systemd Services"
        "♻️  Restore Systemd Services"
        "🎨 Initialize Theme"
    )

    choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "Dotfiles" -theme-str 'window {width: 500px;}')

    case "$choice" in
        "📂 Open Dotfiles Terminal")
            open_dotfiles_terminal
            ;;
        "🔄 Restart Quickshell")
            (
                notify-send "Quickshell" "Restarting..." -t 2000
                pkill -x quickshell
                sleep 0.3
                quickshell &
                sleep 0.5
                if pgrep -x quickshell > /dev/null; then
                    notify-send "Quickshell" "✅ Restarted successfully!" -t 3000
                else
                    notify-send "Quickshell" "❌ Failed to restart!" -u critical -t 5000
                fi
            ) &
            ;;
        "👆 Restart Trackpad Gestures")
            "$HOME/dotfiles/scripts/restart-gestures.sh" &
            ;;
        "🔗 Run link.sh (re-link dotfiles)")
            run_in_background "./link.sh" "Running link.sh" "✅ Dotfiles linked successfully!" "❌ Link failed! Check /tmp/dotfiles-cmd.log"
            ;;
        "🔖 Sync Bookmarks")
            run_in_background "./scripts/sync_bookmarks.sh" "Syncing bookmarks" "✅ Bookmarks synced successfully!" "❌ Sync failed! Check /tmp/dotfiles-cmd.log"
            ;;
        "💾 Backup Systemd Services")
            run_in_background "./scripts/backup_systemd_services.sh" "Backing up systemd services" "✅ Backup completed!" "❌ Backup failed! Check /tmp/dotfiles-cmd.log"
            ;;
        "♻️  Restore Systemd Services")
            run_in_background "./scripts/restore_systemd_services.sh" "Restoring systemd services" "✅ Services restored!" "❌ Restore failed! Check /tmp/dotfiles-cmd.log"
            ;;
        "🎨 Initialize Theme")
            run_in_background "./scripts/hypr-theme-init.sh" "Initializing theme" "✅ Theme initialized!" "❌ Theme init failed! Check /tmp/dotfiles-cmd.log"
            ;;
    esac
}

# Main logic
show_menu
