#!/bin/bash
# Rofi audio sink (output) selector

# Get current default sink
default_sink=$(pactl get-default-sink)

# Get list of sinks with their descriptions, filtered to preferred devices
sinks=$(pactl list sinks | grep -E "Name:|Description:" | paste - - | sed 's/\tDescription: / | /' | grep -E "PRO X|RODE AI-1")

# Format for rofi: show description, store name
options=""
while IFS= read -r line; do
    [ -z "$line" ] && continue
    name=$(echo "$line" | sed 's/.*Name: \([^ ]*\).*/\1/' | tr -d '\t')
    desc=$(echo "$line" | sed 's/.*| //')
    # Friendly display names
    display="$desc"
    case "$desc" in
        *"RODE AI-1"*) display="Speakers (Rode)" ;;
        *"PRO X"*) display="Headset (PRO X)" ;;
    esac
    if [ "$name" = "$default_sink" ]; then
        options+="● $display\n"
    else
        options+="  $display\n"
    fi
done <<< "$sinks"

# Show rofi menu
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Audio Output" -theme-str 'window {width: 400px;}')

if [ -n "$chosen" ]; then
    # Remove the bullet/space prefix and find matching sink
    chosen_desc=$(echo "$chosen" | sed 's/^[● ] //')

    # Find the sink name that matches this description
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        name=$(echo "$line" | sed 's/.*Name: \([^ ]*\).*/\1/' | tr -d '\t')
        desc=$(echo "$line" | sed 's/.*| //')
        display="$desc"
        case "$desc" in
            *"USB Audio Speakers"*) display="Speakers (Rode)" ;;
            *"USB Audio Front Headphones"*) display="Headphones (Rode)" ;;
            *"USB Audio S/PDIF"*) display="S/PDIF (Rode)" ;;
            *"PRO X"*) display="Headset (PRO X)" ;;
        esac
        if [ "$display" = "$chosen_desc" ]; then
            pactl set-default-sink "$name"
            notify-send "Audio Output" "Switched to: $desc" -t 2000
            break
        fi
    done <<< "$sinks"
fi
