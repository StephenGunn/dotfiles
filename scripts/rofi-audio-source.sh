#!/bin/bash
# Rofi audio source (input/microphone) selector

# Get current default source
default_source=$(pactl get-default-source)

# Get list of sources with their descriptions (filter out monitors)
sources=$(pactl list sources | grep -E "Name:|Description:" | paste - - | sed 's/\tDescription: / | /' | grep -v "Monitor")

# Format for rofi: show description, store name
options=""
while IFS= read -r line; do
    [ -z "$line" ] && continue
    name=$(echo "$line" | sed 's/.*Name: \([^ ]*\).*/\1/')
    desc=$(echo "$line" | sed 's/.*| //')
    if [ "$name" = "$default_source" ]; then
        options+="● $desc\n"
    else
        options+="  $desc\n"
    fi
done <<< "$sources"

# Show rofi menu
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Audio Input" -theme-str 'window {width: 400px;}')

if [ -n "$chosen" ]; then
    # Remove the bullet/space prefix and find matching source
    chosen_desc=$(echo "$chosen" | sed 's/^[● ] //')

    # Find the source name that matches this description
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        name=$(echo "$line" | sed 's/.*Name: \([^ ]*\).*/\1/')
        desc=$(echo "$line" | sed 's/.*| //')
        if [ "$desc" = "$chosen_desc" ]; then
            pactl set-default-source "$name"
            notify-send "Audio Input" "Switched to: $desc" -t 2000
            break
        fi
    done <<< "$sources"
fi
