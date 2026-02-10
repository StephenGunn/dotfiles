# Tablet-specific packages (surfarch - Surface Pro 8)
# Touch-friendly, lightweight, tablet optimizations

# === Surface-specific ===
# Note: linux-surface kernel should be installed separately
# See: https://github.com/linux-surface/linux-surface
iptsd                          # Touch & pen input daemon (Intel Precise Touch)

# === Kernel ===
# linux-surface and linux-surface-headers from linux-surface repo
# See: https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup
# Must boot into linux-surface kernel for touch to work

# === Services to enable ===
# iptsd is auto-started via udev when IPTS device is detected
# If not, manually: sudo systemctl enable --now iptsd@<device>

# === On-screen keyboard ===
# AUR:squeekboard  # Wayland on-screen keyboard (if needed)

# === Touch-friendly apps ===
# (most touch support comes from libinput-gestures in core)

# === Lighter alternatives ===
# Using ghostty from core instead of multiple terminal emulators
