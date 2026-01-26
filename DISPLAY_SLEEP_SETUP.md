# Display Sleep Setup

## Problem
Physically turning off monitors causes Hyprland to reconfigure workspaces, which breaks HyprPanel's workspace tracking.

## Solution
Use a script to turn off displays via DPMS (power management) instead of physical power button.

## The Script

Located at: `~/.local/bin/hypr-display-sleep`

This script:
- Turns off displays using `hyprctl dispatch dpms off`
- Does NOT suspend the system (your session stays alive)
- Monitors automatically wake on keyboard/mouse input
- Hyprland doesn't reconfigure monitors, so HyprPanel stays happy

## How to Use

### Option 1: Configure HyprPanel Sleep Button

The sleep button in HyprPanel can be configured to run this command.

**To configure HyprPanel's sleep button:**

You need to modify HyprPanel's settings. HyprPanel is based on AGS (Aylur's GTK Shell), and the power menu configuration would be in the HyprPanel source/config.

According to the HyprPanel config at `~/.config/hyprpanel/config.json`, there's a power menu with a sleep button. The default behavior is likely `systemctl suspend`.

**Steps:**
1. Check HyprPanel documentation for custom command configuration
2. Or modify the HyprPanel source to call `hypr-display-sleep` instead
3. Alternative: Use a keybind or rofi menu (see below)

### Option 2: Add a Keybind in Hyprland

Add this to `~/.config/hypr/hyprland.conf`:

```conf
bind = $mainMod SHIFT, S, exec, hypr-display-sleep
```

Then reload Hyprland config: `Super + Shift + R` or restart Hyprland.

### Option 3: Command Line

Just run it manually when you're done for the night:

```bash
hypr-display-sleep
```

### Option 4: Create a Rofi Menu Entry

If you want to add it to rofi, you would need to create or modify a rofi power menu script. Currently, your config shows rofi for app launching (`$menu = rofi -show drun`), but I don't see a custom power menu.

To create a simple rofi power menu, create `~/.local/bin/rofi-power-menu`:

```bash
#!/usr/bin/env bash

options="Display Sleep\nLock\nLogout\nRestart\nShutdown"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu")

case $chosen in
    "Display Sleep")
        hypr-display-sleep
        ;;
    "Lock")
        # Add lock command if you set one up
        notify-send "Lock not configured"
        ;;
    "Logout")
        hyprctl dispatch exit
        ;;
    "Restart")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
esac
```

Then bind it in `hyprland.conf`:
```conf
bind = $mainMod, Escape, exec, rofi-power-menu
```

## Testing

**SAFE TO TEST:** This script only turns off displays, it does NOT suspend your system.

1. Run: `hypr-display-sleep`
2. Your displays should turn off
3. Move mouse or press any key - displays should wake up
4. Check that HyprPanel workspaces still work correctly

## What About Overnight?

For overnight operation:
- **Just turn off displays:** Run `hypr-display-sleep` - system stays on, uses ~50-100W
- **Want lower power?** Consider installing `hypridle` for automatic suspend after extended idle

## Future: Automatic Idle (Optional)

If you want automatic behavior later (e.g., auto-suspend after 30 minutes of idle), install `hypridle`:

```bash
sudo pacman -S hypridle
```

Then create `~/.config/hypr/hypridle.conf` with timeouts as needed.

## Notes

- The script is symlinked via GNU Stow from `~/dotfiles/.local/bin/`
- Run `./link.sh` from dotfiles directory if the script isn't available
- Your monitors will wake automatically on ANY input (keyboard, mouse, etc.)
