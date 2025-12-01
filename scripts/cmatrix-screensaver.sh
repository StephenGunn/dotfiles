#!/usr/bin/env bash
# cmatrix screensaver - toggle on/off

# Check if cmatrix is already running
if pgrep -f "kitty.*cmatrix" > /dev/null; then
    # Kill existing cmatrix instances
    pkill -f "kitty.*cmatrix"
else
    # Launch cmatrix on both monitors (window rules handle fullscreen and positioning)
    # -r for rainbow mode, -u 5 for slower speed, -s for screensaver mode (exit on keypress)
    kitty --class cmatrix-1 -e cmatrix -r -u 5 -s &
    kitty --class cmatrix-2 -e cmatrix -r -u 5 -s &
fi
