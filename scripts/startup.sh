#!/bin/bash

# Launch Obsidian on workspace 4
hyprctl dispatch workspace 4
sleep 0.2
obsidian &   # Launch Obsidian in the background

# Launch Discord on workspace 5
hyprctl dispatch workspace 5
sleep 0.2
discord &    # Launch Discord in the background
