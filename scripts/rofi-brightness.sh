#!/bin/bash
# Rofi brightness menu with display toggle

# Always set brightness to 50% first (wakes screen if at zero)
brightnessctl set 50%

# Get current brightness percentage
current=50

# Build brightness options with indicator for current level
levels=(5 10 20 30 40 50 60 70 80 90 100)
options=""
for level in "${levels[@]}"; do
    if [ "$current" -ge "$((level - 4))" ] && [ "$current" -le "$((level + 4))" ]; then
        options+="● 󰃠 ${level}%\n"
    else
        options+="  󰃠 ${level}%\n"
    fi
done

# Add display off option on laptops
if [[ "$(cat /etc/hostname)" == "surfarch" || "$(cat /etc/hostname)" == "titan" ]]; then
    options+="  󰶐 Display Off\n"
fi

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Brightness (${current}%)" -theme-str 'window {width: 280px;}')

if [ -n "$chosen" ]; then
    case "$chosen" in
        *"Display Off"*)
            ~/dotfiles/scripts/display-toggle.sh
            ;;
        *)
            level=$(echo "$chosen" | grep -oP '\d+(?=%)')
            brightnessctl set "${level}%"
            notify-send "Brightness" "Set to ${level}%" -t 2000
            ;;
    esac
fi
