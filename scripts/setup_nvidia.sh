#!/bin/bash

# ============================================================================
# NVIDIA DRIVER SETUP - Hybrid laptops (AMD/Intel iGPU + NVIDIA dGPU)
# ============================================================================
# Installs the open NVIDIA kernel modules and rebuilds the initramfs/UKI.
#
# Built for titan (HP OMEN MAX 16: Radeon 890M + RTX 5080), but generic.
#
# Why nvidia-open-dkms and not nvidia-open:
#   - Blackwell (RTX 50xx) is only supported by the OPEN kernel modules.
#     The proprietary `nvidia` package will not drive this card at all.
#   - `nvidia-open` builds against the `linux` kernel only. This machine also
#     has `linux-zen` installed, and booting it would black-screen. The DKMS
#     variant builds for every installed kernel.
#
# IMPORTANT: nouveau cannot drive Blackwell and hangs at boot, which is why
# `nomodeset` was needed to install. Do NOT remove nomodeset until this script
# has run successfully -- nvidia-utils ships the nouveau blacklist.
#
# Safe to re-run: every step is idempotent.
# ============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PACMAN_CONF="/etc/pacman.conf"
MKINITCPIO_CONF="/etc/mkinitcpio.conf"
NV_MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     NVIDIA Driver Setup                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# ----------------------------------------------------------------------------
# Preflight
# ----------------------------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}Re-running with sudo...${NC}"
    exec sudo -- "$0" "$@"
fi

if ! lspci | grep -qi "nvidia"; then
    echo -e "${RED}✗ No NVIDIA GPU found on this machine. Aborting.${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} NVIDIA GPU detected:"
lspci | grep -i "nvidia.*\(VGA\|3D\)" | sed 's/^/    /'
echo ""

# Back up every file we touch, once per run.
BACKUP_DIR="/root/nvidia-setup-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo -e "${BLUE}→${NC} Backups: $BACKUP_DIR"
echo ""

# ----------------------------------------------------------------------------
# Step 1: Enable multilib (needed for lib32-nvidia-utils / Steam)
# ----------------------------------------------------------------------------
echo -e "${BLUE}[1/6]${NC} Enabling multilib repository..."

if grep -qE '^\[multilib\]' "$PACMAN_CONF"; then
    echo -e "  ${GREEN}✓${NC} Already enabled"
else
    cp "$PACMAN_CONF" "$BACKUP_DIR/pacman.conf"
    # Uncomment the "#[multilib]" line and the "#Include" line directly after it.
    # Anchored to end-of-line so it can never match [multilib-testing].
    sed -i '/^#\[multilib\]$/{s/^#//;n;s/^#//}' "$PACMAN_CONF"

    if grep -qE '^\[multilib\]' "$PACMAN_CONF"; then
        echo -e "  ${GREEN}✓${NC} Enabled"
    else
        echo -e "  ${RED}✗ Could not enable multilib automatically.${NC}"
        echo -e "    Uncomment these two lines in $PACMAN_CONF and re-run:"
        echo -e "      [multilib]"
        echo -e "      Include = /etc/pacman.d/mirrorlist"
        exit 1
    fi
fi

echo -e "  ${BLUE}→${NC} Syncing package databases..."
pacman -Sy --noconfirm >/dev/null
echo ""

# ----------------------------------------------------------------------------
# Step 2: Install driver packages
# ----------------------------------------------------------------------------
echo -e "${BLUE}[2/6]${NC} Installing NVIDIA packages..."

PACKAGES=(
    dkms
    nvidia-open-dkms
    nvidia-utils
    lib32-nvidia-utils
    nvidia-settings
)

# DKMS needs headers for every installed kernel, or the build silently
# skips that kernel and it black-screens on boot.
for kernel in linux linux-zen linux-lts; do
    if pacman -Qq "$kernel" &>/dev/null; then
        PACKAGES+=("${kernel}-headers")
        echo -e "  ${BLUE}→${NC} Kernel '$kernel' installed, adding ${kernel}-headers"
    fi
done

pacman -S --needed --noconfirm "${PACKAGES[@]}"
echo -e "  ${GREEN}✓${NC} Packages installed"

# nouveau userspace conflicts with the NVIDIA stack (duplicate Vulkan ICDs).
NOUVEAU_PKGS=()
for pkg in xf86-video-nouveau vulkan-nouveau; do
    # 'if' rather than '&&' so a not-installed package on the final iteration
    # doesn't make the loop exit non-zero and trip 'set -e'.
    if pacman -Qq "$pkg" &>/dev/null; then
        NOUVEAU_PKGS+=("$pkg")
    fi
done

if [ ${#NOUVEAU_PKGS[@]} -gt 0 ]; then
    echo -e "  ${BLUE}→${NC} Removing nouveau userspace: ${NOUVEAU_PKGS[*]}"
    pacman -Rns --noconfirm "${NOUVEAU_PKGS[@]}"
fi
echo ""

# ----------------------------------------------------------------------------
# Step 3: Early KMS - add nvidia modules to the initramfs
# ----------------------------------------------------------------------------
echo -e "${BLUE}[3/6]${NC} Configuring early KMS in mkinitcpio.conf..."

if grep -qE '^MODULES=.*nvidia' "$MKINITCPIO_CONF"; then
    echo -e "  ${GREEN}✓${NC} nvidia modules already present"
else
    cp "$MKINITCPIO_CONF" "$BACKUP_DIR/mkinitcpio.conf"

    # Preserve any modules already listed rather than clobbering the line.
    CURRENT=$(sed -n 's/^MODULES=(\(.*\))$/\1/p' "$MKINITCPIO_CONF")
    NEW=$(echo "$CURRENT $NV_MODULES" | xargs)   # xargs collapses whitespace
    sed -i "s|^MODULES=(.*)$|MODULES=($NEW)|" "$MKINITCPIO_CONF"

    echo -e "  ${GREEN}✓${NC} $(grep '^MODULES=' "$MKINITCPIO_CONF")"
fi
echo ""

# ----------------------------------------------------------------------------
# Step 4: Enable fallback images - the safety net if the default won't boot
# ----------------------------------------------------------------------------
echo -e "${BLUE}[4/6]${NC} Enabling fallback boot images..."

for preset in /etc/mkinitcpio.d/*.preset; do
    [ -e "$preset" ] || continue
    name=$(basename "$preset" .preset)

    if grep -qE "^PRESETS=.*fallback" "$preset"; then
        echo -e "  ${GREEN}✓${NC} $name: fallback already enabled"
        continue
    fi

    cp "$preset" "$BACKUP_DIR/$(basename "$preset")"

    sed -i "s|^PRESETS=('default')|PRESETS=('default' 'fallback')|" "$preset"
    # These are shipped commented out; the fallback needs them to be useful.
    # '-S autodetect' skips module autodetection so ALL modules are included.
    sed -i 's|^#fallback_options=|fallback_options=|' "$preset"
    sed -i 's|^#fallback_uki=|fallback_uki=|' "$preset"
    sed -i 's|^##*fallback_image=|#fallback_image=|' "$preset"

    echo -e "  ${GREEN}✓${NC} $name: fallback enabled"
done
echo ""

# ----------------------------------------------------------------------------
# Step 5: Rebuild initramfs / UKIs
# ----------------------------------------------------------------------------
echo -e "${BLUE}[5/6]${NC} Rebuilding initramfs (this takes a minute)..."
echo ""

if ! mkinitcpio -P; then
    echo ""
    echo -e "${RED}✗ mkinitcpio FAILED.${NC}"
    echo -e "${RED}  DO NOT REBOOT without nomodeset. Backups: $BACKUP_DIR${NC}"
    exit 1
fi
echo ""

# ----------------------------------------------------------------------------
# Step 6: Verify the modules actually built
# ----------------------------------------------------------------------------
echo -e "${BLUE}[6/6]${NC} Verifying..."

FAILED=0

if modinfo nvidia &>/dev/null; then
    echo -e "  ${GREEN}✓${NC} nvidia module: $(modinfo -F version nvidia 2>/dev/null || echo 'built')"
else
    echo -e "  ${RED}✗${NC} nvidia module not found by modinfo"
    FAILED=1
fi

# Every installed kernel must have the module built, or booting that kernel
# black-screens. Count what DKMS actually produced and compare.
KERNELS_INSTALLED=0
for kernel in linux linux-zen linux-lts; do
    if pacman -Qq "$kernel" &>/dev/null; then
        KERNELS_INSTALLED=$((KERNELS_INSTALLED + 1))
    fi
done

BUILT=0
for moddir in /usr/lib/modules/*/; do
    kver=$(basename "$moddir")
    if compgen -G "${moddir}updates/dkms/nvidia.ko*" >/dev/null; then
        echo -e "  ${GREEN}✓${NC} $kver: nvidia module built"
        BUILT=$((BUILT + 1))
    fi
done

if [ "$BUILT" -eq 0 ]; then
    echo -e "  ${RED}✗${NC} No nvidia module built for any kernel"
    FAILED=1
elif [ "$BUILT" -lt "$KERNELS_INSTALLED" ]; then
    echo -e "  ${YELLOW}⚠${NC} Built for $BUILT kernel(s) but $KERNELS_INSTALLED installed."
    echo -e "    Booting a kernel without the module will black-screen."
    echo -e "    Check 'dkms status' below before rebooting."
fi

echo ""
echo -e "  ${BLUE}→${NC} dkms status:"
dkms status 2>/dev/null | sed 's/^/      /' || echo "      (none)"

echo ""
if [ "$FAILED" -ne 0 ]; then
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  VERIFICATION FAILED - DO NOT REBOOT       ║${NC}"
    echo -e "${RED}║  without nomodeset on the kernel cmdline.  ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    exit 1
fi

echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     NVIDIA setup complete                  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Reboot WITHOUT nomodeset (just don't type it at the boot menu)."
echo "     If it fails to boot, pick the 'fallback' entry, or press 'e' and"
echo "     re-add nomodeset. You will not be locked out."
echo ""
echo "  2. After booting, verify:"
echo "       nvidia-smi                 # driver talking to the card"
echo "       ls /dev/dri/               # want card1 + renderD128"
echo "       hyprctl monitors | head -3 # want eDP-1 @ 240Hz, not Unknown-1"
echo ""
echo "  3. Render a game/app on the dGPU with:  prime-run <command>"
echo ""
