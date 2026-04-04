#!/bin/bash
# Toggle display on/off without suspending
# OBS and other processes keep running when display is off

STATE_FILE="/tmp/display-off"

if [[ -f "$STATE_FILE" ]]; then
    hyprctl dispatch dpms on
    rm "$STATE_FILE"
else
    hyprctl dispatch dpms off
    touch "$STATE_FILE"
fi
