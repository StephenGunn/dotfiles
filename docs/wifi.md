# WiFi Setup

WiFi is managed through NetworkManager via the `wifi` fish function.

## Quick Start

```bash
# scan for networks
wifi list

# connect to a network
wifi connect "MyNetwork"

# give it a friendly name
wifi alias "MyNetwork" "Home"
```

From now on, the connection shows up as "Home" everywhere.

## Commands

```
wifi              show current connection status
wifi list         scan and list available networks
wifi connect <n>  connect to a network by SSID
wifi alias <o> <n> rename a saved connection
wifi saved        list saved connections
wifi forget <n>   delete a saved connection
wifi on / off     toggle wifi radio
```

## First Time on a New Network

1. `wifi list` to see what's around
2. `wifi connect "SSID"` - you'll be prompted for a password
3. `wifi alias "SSID" "Something Nice"` to rename it

The password is saved automatically. Next time you're in range it connects on its own.

## Troubleshooting

```bash
# check if wifi radio is on
nmcli radio wifi

# restart NetworkManager
sudo systemctl restart NetworkManager

# see full device details
nmcli device show wlan0

# manually re-scan
nmcli device wifi rescan
```
