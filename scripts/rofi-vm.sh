#!/bin/bash
# Rofi menu for VM management (win11 via libvirt/Looking Glass)

VM_NAME="win11"
VIRSH="virsh -c qemu:///system"
LG_CMD="looking-glass-client"
LG_ARGS="-f /dev/shm/looking-glass -S -m 88"

# Get VM state
VM_STATE=$($VIRSH domstate "$VM_NAME" 2>/dev/null | tr -d '[:space:]')

if [[ "$VM_STATE" == "running" ]]; then
    VM_STATUS="RUNNING"
    VM_ICON="󰍹"
else
    VM_STATUS="OFF"
    VM_ICON="󰍹"
fi

# Check if Looking Glass is running
LG_RUNNING=$(pgrep -f "looking-glass-client" 2>/dev/null)

# Build menu dynamically
main_menu() {
    local options="$VM_ICON Windows VM [$VM_STATUS]
───────────────────"

    if [[ "$VM_STATUS" == "OFF" ]]; then
        options+="
 Start VM"
    else
        options+="
 Shutdown VM
 Force Stop VM
───────────────────"
        if [[ -n "$LG_RUNNING" ]]; then
            options+="
󰹑 Focus Looking Glass"
        else
            options+="
󰹑 Launch Looking Glass"
        fi
    fi

    options+="
 Open virt-manager"

    echo "$options" | rofi -dmenu -i -p "VM" -theme-str 'window {width: 350px;}'
}

choice=$(main_menu)

case "$choice" in
    *"Start VM"*)
        $VIRSH start "$VM_NAME"
        notify-send "VM" "Starting $VM_NAME..." -t 3000
        ;;
    *"Shutdown VM"*)
        $VIRSH shutdown "$VM_NAME"
        notify-send "VM" "Shutting down $VM_NAME..." -t 3000
        ;;
    *"Force Stop"*)
        $VIRSH destroy "$VM_NAME"
        notify-send "VM" "Force stopped $VM_NAME" -t 3000
        ;;
    *"Launch Looking Glass"*)
        $LG_CMD $LG_ARGS &
        disown
        notify-send "VM" "Looking Glass started" -t 2000
        ;;
    *"Focus Looking Glass"*)
        hyprctl dispatch focuswindow "class:^(looking-glass-client)$"
        ;;
    *"virt-manager"*)
        virt-manager &
        disown
        ;;
esac
