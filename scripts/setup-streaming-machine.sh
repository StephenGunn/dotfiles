#!/bin/bash
# One-time setup for a 24/7 streaming machine
# Prevents all forms of system sleep/suspend so OBS can stream uninterrupted
#
# What this does:
#   1. Masks systemd sleep/suspend/hibernate targets
#   2. Configures logind to ignore lid switch and idle actions
#   3. Symlinks hypridle to the no-suspend variant for this host
#
# Usage: sudo ./setup-streaming-machine.sh
# Undo:  sudo ./setup-streaming-machine.sh --undo

set -euo pipefail

HOSTNAME=$(cat /etc/hostname)
HYPR_DIR="$HOME/.config/hypr"
HYPRIDLE_HOST="$HYPR_DIR/hosts/hypridle-${HOSTNAME}.conf"
LOGIND_DROP="/etc/systemd/logind.conf.d/no-sleep.conf"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[+]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[x]${NC} $1"; exit 1; }

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root (sudo)"
    fi
}

# Verify the host has a no-suspend hypridle config
check_hypridle_config() {
    if [[ ! -f "$HYPRIDLE_HOST" ]]; then
        warn "No host-specific hypridle config found at: $HYPRIDLE_HOST"
        warn "You may need to create one without a suspend listener."
        return 1
    fi

    if grep -q "systemctl suspend" "$HYPRIDLE_HOST"; then
        warn "$HYPRIDLE_HOST contains 'systemctl suspend' - this will still suspend!"
        warn "Remove the suspend listener from that file."
        return 1
    fi

    info "Host hypridle config looks good (no suspend listener)"
    return 0
}

setup() {
    check_root

    echo "Setting up $(cat /etc/hostname) as a 24/7 streaming machine..."
    echo ""

    # 1. Mask systemd sleep targets
    info "Masking systemd sleep targets..."
    systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    info "Masked: sleep, suspend, hibernate, hybrid-sleep"

    # 2. Configure logind
    info "Configuring logind to ignore lid/idle actions..."
    mkdir -p /etc/systemd/logind.conf.d
    cat > "$LOGIND_DROP" <<EOF
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
IdleAction=ignore
EOF
    info "Created $LOGIND_DROP"

    # 3. Restart logind to pick up changes
    info "Restarting systemd-logind..."
    systemctl restart systemd-logind

    # 4. Check hypridle config (non-root, just advisory)
    echo ""
    check_hypridle_config || true

    # 5. Symlink hypridle if the host config exists
    if [[ -f "$HYPRIDLE_HOST" ]]; then
        local target="$HYPR_DIR/hypridle.conf"
        if [[ -L "$target" ]] && [[ "$(readlink -f "$target")" == "$(realpath "$HYPRIDLE_HOST")" ]]; then
            info "hypridle.conf already symlinked to host config"
        else
            ln -sf "$HYPRIDLE_HOST" "$target"
            info "Symlinked hypridle.conf -> $(basename "$HYPRIDLE_HOST")"
        fi
    fi

    echo ""
    info "Done! Verify with:"
    echo "  systemctl status sleep.target suspend.target"
    echo "  cat /etc/systemd/logind.conf.d/no-sleep.conf"
    echo "  readlink ~/.config/hypr/hypridle.conf"
}

undo() {
    check_root

    echo "Reverting 24/7 streaming setup on $(cat /etc/hostname)..."
    echo ""

    # 1. Unmask sleep targets
    info "Unmasking systemd sleep targets..."
    systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target

    # 2. Remove logind override
    if [[ -f "$LOGIND_DROP" ]]; then
        rm "$LOGIND_DROP"
        info "Removed $LOGIND_DROP"
    fi

    # 3. Restart logind
    info "Restarting systemd-logind..."
    systemctl restart systemd-logind

    echo ""
    info "Sleep/suspend re-enabled. You may want to re-symlink hypridle.conf to the default config."
}

case "${1:-}" in
    --undo|undo|--revert|revert)
        undo
        ;;
    --help|-h)
        echo "Usage: sudo $0 [--undo]"
        echo ""
        echo "Sets up this machine for 24/7 streaming by disabling all sleep/suspend."
        echo "Use --undo to revert changes."
        ;;
    *)
        setup
        ;;
esac
