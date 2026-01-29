# Magic Trackpad Gesture Fix After Sleep/Wake

## Problem
After waking from sleep, the Magic Trackpad reconnects via Bluetooth but libinput-gestures stops working. Gestures only work again after manually restarting the service.

## Solution 1: Bluetooth Resume Delay (Current Approach)

Configure Bluetooth to have a resume delay, giving the trackpad time to reconnect before libinput-gestures tries to access it.

### Steps:
1. Edit `/etc/bluetooth/main.conf` (requires sudo)
2. Add or modify these settings under `[General]`:
   ```
   ResumeDelay = 2
   AutoEnable = true
   ```
3. Restart Bluetooth service: `sudo systemctl restart bluetooth`
4. Test sleep/wake cycle

## Solution 2: Systemd Sleep Hook (Alternative if Solution 1 doesn't work)

Create a systemd service that automatically restarts libinput-gestures after waking from sleep.

### Steps:
1. Create `/etc/systemd/system/libinput-gestures-resume.service`:
   ```
   [Unit]
   Description=Restart libinput-gestures after suspend
   After=suspend.target

   [Service]
   Type=oneshot
   ExecStart=/usr/bin/systemctl --user restart libinput-gestures

   [Install]
   WantedBy=suspend.target
   ```

2. Enable the service:
   ```
   sudo systemctl enable libinput-gestures-resume.service
   ```

3. Test sleep/wake cycle

## Notes
- Current service status: `systemctl --user status libinput-gestures`
- Manual restart: `systemctl --user restart libinput-gestures`
- Trackpad device: `D0:C0:50:D1:6C:15 Magic Trackpad`
- Hyprland already has `exec-once = systemctl --user restart libinput-gestures` in autostart.conf (line 21) - this can be removed if systemd solution works
