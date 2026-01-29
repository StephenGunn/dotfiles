# Magic Trackpad Gesture Issues - Diagnosis

## Problem Description

Magic Trackpad USB-C gestures intermittently stop working while cursor movement remains functional. This requires manually restarting the `libinput-gestures` service to restore gesture functionality.

## Root Causes

### 1. Kernel/Driver Bug - Touch Jump Errors

The primary issue is a known kernel bug with Apple Magic Trackpads where libinput detects and discards "touch jumps":

```
libinput error: event18 - Apple Inc. Magic Trackpad USB-C: kernel bug: Touch jump detected and discarded.
See https://wayland.freedesktop.org/libinput/doc/1.30.1/touchpad-jumping-cursors.html for details
```

- Occurs at the hardware/driver level
- Causes libinput to discard touch events for safety
- Affects gesture recognition but not basic cursor movement (handled at lower level)
- Log rate limited to 5 messages per 24 hours after initial occurrence

### 2. Service State Issue

The `libinput-gestures` daemon continues running but stops recognizing gesture patterns when touch jump errors occur frequently. The service appears active but becomes non-functional for gestures.

## Current Configuration

### Device Details
- **Device**: Apple Inc. Magic Trackpad USB-C
- **Connection**: Bluetooth
- **Event Device**: `/dev/input/event18`
- **libinput Version**: 1.30.1-1

### Service Status
- **Service**: `libinput-gestures.service`
- **Status**: Enabled and running
- **Auto-restart**: Configured in `.config/hypr/autostart.conf:21`

### Gesture Configuration
Located in `.config/libinput-gestures.conf`:
- 3-finger swipe: Workspace switching
- 4-finger swipe: Window management (fullscreen/floating toggle)
- 2-finger pinch: Volume control

## Solution - Manual Restart

### Quick Fix Script
Created: `~/dotfiles/scripts/restart-gestures.sh`

```bash
#!/usr/bin/env bash
# Restart libinput-gestures service
systemctl --user restart libinput-gestures
```

### Access Methods

1. **Direct command**:
   ```bash
   ~/dotfiles/scripts/restart-gestures.sh
   ```

2. **Via Rofi Menu**:
   - Open dotfiles menu (`.config/hypr/scripts/dotfiles-workspace.sh`)
   - Select "👆 Restart Trackpad Gestures"
   - Desktop notification confirms success/failure

## Potential Future Investigations

If the issue persists or worsens, consider investigating:

1. **Pattern Analysis**: Monitor when gestures fail
   - After sleep/wake cycles?
   - After Bluetooth reconnection?
   - Time-based intervals?
   - Check logs: `journalctl --user -u libinput-gestures`

2. **Bluetooth Connection Logs**: Correlate gesture failures with Bluetooth events
   ```bash
   journalctl -u bluetooth --since "1 hour ago"
   ```

3. **Kernel Parameters/Quirks**: Research libinput quirks for Apple Magic Trackpad
   - Check libinput device-specific settings
   - Look for kernel parameters to mitigate touch jump detection

4. **Automatic Recovery**: Implement monitoring script
   - Systemd timer to check gesture functionality
   - Auto-restart service if gestures become unresponsive
   - Log incidents for pattern analysis

## Related Files

- Gesture config: `.config/libinput-gestures.conf`
- Input config: `.config/hypr/input.conf:40-56`
- Autostart: `.config/hypr/autostart.conf:21`
- Restart script: `scripts/restart-gestures.sh`
- Rofi menu: `.config/hypr/scripts/dotfiles-workspace.sh:88-90`

## References

- [libinput Touch Jump Documentation](https://wayland.freedesktop.org/libinput/doc/1.30.1/touchpad-jumping-cursors.html)
- libinput-gestures: `systemctl --user status libinput-gestures`
