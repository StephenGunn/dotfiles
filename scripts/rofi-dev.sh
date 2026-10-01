#!/bin/bash
# Rofi menu for tmux sessions and dev project launchers
# Shows running tmux sessions at top, project launchers below

PROJECTS_DIR="$HOME/.config/dev-projects"
SEPARATOR="───────────────"

# Build tmux sessions list
build_sessions() {
    echo " New Session"
    echo " Kill Session"
    if tmux list-sessions 2>/dev/null | grep -q .; then
        tmux list-sessions -F '#{session_name} (#{session_windows} windows)' 2>/dev/null | while read -r line; do
            echo " $line"
        done
    fi
    echo "$SEPARATOR"
}

# Build project launchers list
build_projects() {
    for conf in "$PROJECTS_DIR"/*.conf; do
        [[ -f "$conf" ]] || continue
        source "$conf"
        echo "$ICON $NAME"
        unset NAME ICON SCRIPT
    done
}

# Show menu
choice=$(printf '%s\n' "$(build_sessions)" "$(build_projects)" | grep -v '^$' | rofi -dmenu -i -p "  Dev" -theme-str 'window {width: 400px;}')
[[ -z "$choice" ]] && exit 0

# Ignore separator
[[ "$choice" == "$SEPARATOR" ]] && exit 0

# Handle kill session
if [[ "$choice" == " Kill Session" ]]; then
    sessions=$(tmux list-sessions -F '#{session_name} (#{session_windows} windows)' 2>/dev/null)
    [[ -z "$sessions" ]] && exit 0
    target=$(echo "$sessions" | rofi -dmenu -i -p "  Kill" -theme-str 'window {width: 400px;}')
    [[ -z "$target" ]] && exit 0
    session_name=$(echo "$target" | sed 's/ (.*//')
    tmux kill-session -t "$session_name"
    notify-send "Tmux" "Killed session: $session_name" -t 2000
    exit 0
fi

# Handle new session
if [[ "$choice" == " New Session" ]]; then
    name=$(rofi -dmenu -p "  Session Name" -theme-str 'window {width: 400px;}')
    [[ -z "$name" ]] && exit 0
    tmux new-session -d -s "$name"
    exec ghostty -e tmux attach -t "$name"
fi

# Handle tmux session selection
if [[ "$choice" == " "* ]]; then
    session_name=$(echo "$choice" | sed 's/^ //' | sed 's/ (.*//')
    exec ghostty -e tmux attach -t "$session_name"
fi

# Handle project selection
for conf in "$PROJECTS_DIR"/*.conf; do
    [[ -f "$conf" ]] || continue
    source "$conf"
    if [[ "$choice" == "$ICON $NAME" ]]; then
        exec bash "$SCRIPT"
    fi
    unset NAME ICON SCRIPT
done
