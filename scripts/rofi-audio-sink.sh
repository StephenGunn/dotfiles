#!/bin/bash
# Rofi audio sink (output) selector

# Get current default sink
default_sink=$(pactl get-default-sink)

# Get list of sinks with their descriptions
sinks=$(pactl list sinks | grep -E "Name:|Description:" | paste - - | sed 's/\tDescription: / | /')

# Format for rofi: show description, store name
options=""
while IFS= read -r line; do
    name=$(echo "$line" | sed 's/.*Name: \([^ ]*\).*/\1/')
    desc=$(echo "$line" | sed 's/.*| //')
    if [ "$name" = "$default_sink" ]; then
        options+="● $desc\n"
    else
        options+="  $desc\n"
    fi
done <<< "$sinks"

# Show rofi menu
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Audio Output" -theme-str 'window {width: 400px;}')

if [ -n "$chosen" ]; then
    # Remove the bullet/space prefix and find matching sink
    chosen_desc=$(echo "$chosen" | sed 's/^[● ] //')

    # Find the sink name that matches this description
    while IFS= read -r line; do
        name=$(echo "$line" | sed 's/.*Name: \([^ ]*\).*/\1/')
        desc=$(echo "$line" | sed 's/.*| //')
        if [ "$desc" = "$chosen_desc" ]; then
            pactl set-default-sink "$name"
            notify-send "Audio Output" "Switched to: $desc" -t 2000
            break
        fi
    done <<< "$sinks"
fi
