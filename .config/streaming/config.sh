#!/bin/bash
# Streaming mode configuration
# Edit these values to match your setup

###################
### CAMERAS     ###
###################
# Use v4l2-ctl --list-devices to find your cameras
# Use rofi menu "Swap Cameras" to quickly switch these

CAM_FACE="/dev/video0"      # Face camera
CAM_TOPDOWN="/dev/video2"   # Top-down/desk camera

###################
### MONITOR     ###
###################

MONITOR="DP-2"
MONITOR_RES="2560x1440@165"
MONITOR_WIDTH=2560
MONITOR_HEIGHT=1440

###################
### LAYOUT      ###
###################
# Sidebar on right side of screen
# Adjust SIDEBAR_WIDTH to make sidebar wider/narrower
# Adjust individual Y positions to reorder/reposition windows

SIDEBAR_WIDTH=470           # gap(20) + webcam(430) + edge(20)
SIDEBAR_PADDING=10          # Gap from edge

# Calculated X position (don't change unless custom layout)
MAIN_CONTENT_WIDTH=$((MONITOR_WIDTH - SIDEBAR_WIDTH))
SIDEBAR_X=$((MAIN_CONTENT_WIDTH + SIDEBAR_PADDING))  # 2120

###################
### WINDOW SIZES ##
###################
# 16:9 aspect ratio: width * 9/16 = height

WEBCAM_WIDTH=430
WEBCAM_HEIGHT=242           # 430 * 9/16 = 242
KEYS_HEIGHT=150

###################
### POSITIONS   ###
###################
# Y positions from top of screen
# Panel is ~47px, align with window top

FACE_Y=52                   # Face camera (top)
TOPDOWN_Y=304               # Top-down camera (below face: 52 + 242 + 10 gap)
KEYS_Y=556                  # Keystroke display (below cams)

# Alternative layouts (uncomment to use):

# Layout: Face on top, topdown below
# FACE_Y=230
# TOPDOWN_Y=535

# Layout: No keystroke display, cameras stacked
# KEYS_Y=-999               # Off-screen (hidden)
# FACE_Y=60
# TOPDOWN_Y=365

###################
### MPV SETTINGS ##
###################

MPV_FORMAT="h264"           # h264 or mjpeg
MPV_RESOLUTION="1920x1080"
MPV_FRAMERATE="60"
