#!/bin/bash

# ============================================================================
# DOTFILES INSTALL SCRIPT - Package Management
# ============================================================================
# Installs packages from packages/core.md + packages/$HOSTNAME.md
# Supports pacman and AUR (prefix with AUR:)
# ============================================================================

set -e

DOTFILES_DIR="$HOME/dotfiles"
PACKAGES_DIR="$DOTFILES_DIR/packages"
HOSTNAME=$(cat /etc/hostname)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Dotfiles Package Installer             ║${NC}"
echo -e "${BLUE}║     Host: ${GREEN}$HOSTNAME${BLUE}                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================================
# Parse Package Files
# ============================================================================

parse_packages() {
    local file="$1"
    local pacman_pkgs=()
    local aur_pkgs=()

    if [ ! -f "$file" ]; then
        return
    fi

    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        # Trim whitespace
        line=$(echo "$line" | xargs)

        if [[ "$line" == AUR:* ]]; then
            aur_pkgs+=("${line#AUR:}")
        else
            pacman_pkgs+=("$line")
        fi
    done < "$file"

    # Output arrays (space-separated for easy parsing)
    echo "PACMAN:${pacman_pkgs[*]}"
    echo "AUR:${aur_pkgs[*]}"
}

# Collect all packages
ALL_PACMAN_PKGS=()
ALL_AUR_PKGS=()

echo -e "${YELLOW}📦 Reading package lists...${NC}"

# Read core packages
if [ -f "$PACKAGES_DIR/core.md" ]; then
    echo "  → core.md"
    while IFS= read -r line; do
        if [[ "$line" == PACMAN:* ]]; then
            read -ra pkgs <<< "${line#PACMAN:}"
            ALL_PACMAN_PKGS+=("${pkgs[@]}")
        elif [[ "$line" == AUR:* ]]; then
            read -ra pkgs <<< "${line#AUR:}"
            ALL_AUR_PKGS+=("${pkgs[@]}")
        fi
    done < <(parse_packages "$PACKAGES_DIR/core.md")
fi

# Read host-specific packages
if [ -f "$PACKAGES_DIR/$HOSTNAME.md" ]; then
    echo "  → $HOSTNAME.md"
    while IFS= read -r line; do
        if [[ "$line" == PACMAN:* ]]; then
            read -ra pkgs <<< "${line#PACMAN:}"
            ALL_PACMAN_PKGS+=("${pkgs[@]}")
        elif [[ "$line" == AUR:* ]]; then
            read -ra pkgs <<< "${line#AUR:}"
            ALL_AUR_PKGS+=("${pkgs[@]}")
        fi
    done < <(parse_packages "$PACKAGES_DIR/$HOSTNAME.md")
else
    echo -e "  ${YELLOW}⚠ No host-specific packages for '$HOSTNAME'${NC}"
fi

echo ""
echo -e "${GREEN}Found ${#ALL_PACMAN_PKGS[@]} pacman packages, ${#ALL_AUR_PKGS[@]} AUR packages${NC}"
echo ""

# ============================================================================
# Update System
# ============================================================================

echo -e "${YELLOW}🔄 Updating system...${NC}"
sudo pacman -Syu --noconfirm

# ============================================================================
# Install Pacman Packages
# ============================================================================

echo ""
echo -e "${YELLOW}📦 Installing pacman packages...${NC}"

for pkg in "${ALL_PACMAN_PKGS[@]}"; do
    [ -z "$pkg" ] && continue
    if pacman -Qi "$pkg" &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $pkg (installed)"
    else
        echo -e "  ${BLUE}→${NC} Installing $pkg..."
        if ! sudo pacman -S "$pkg" --noconfirm --needed 2>/dev/null; then
            echo -e "  ${RED}✗${NC} Failed to install $pkg"
        fi
    fi
done

# ============================================================================
# Install AUR Packages
# ============================================================================

echo ""
echo -e "${YELLOW}📦 Installing AUR packages...${NC}"

# Check for yay
if ! command -v yay &>/dev/null; then
    echo -e "${YELLOW}Installing yay first...${NC}"
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd - > /dev/null
fi

for pkg in "${ALL_AUR_PKGS[@]}"; do
    [ -z "$pkg" ] && continue
    if yay -Qi "$pkg" &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $pkg (installed)"
    else
        echo -e "  ${BLUE}→${NC} Installing $pkg..."
        if ! yay -S "$pkg" --noconfirm --needed 2>/dev/null; then
            echo -e "  ${RED}✗${NC} Failed to install $pkg"
        fi
    fi
done

# ============================================================================
# Post-Install: HyprPanel
# ============================================================================

echo ""
echo -e "${YELLOW}🎨 Setting up HyprPanel...${NC}"

if [ ! -d "$HOME/.local/share/HyprPanel" ]; then
    git clone https://github.com/Jas-SinghFSU/HyprPanel.git "$HOME/.local/share/HyprPanel"
    ln -sf "$HOME/.local/share/HyprPanel" "$HOME/.config/ags"

    if [ -f "$HOME/.local/share/HyprPanel/scripts/install_fonts.sh" ]; then
        chmod +x "$HOME/.local/share/HyprPanel/scripts/install_fonts.sh"
        "$HOME/.local/share/HyprPanel/scripts/install_fonts.sh"
    fi
    echo -e "  ${GREEN}✓${NC} HyprPanel installed"
else
    echo -e "  ${GREEN}✓${NC} HyprPanel already installed"
fi

# ============================================================================
# Post-Install: Bun
# ============================================================================

echo ""
echo -e "${YELLOW}📦 Setting up Bun...${NC}"

if [ ! -d "$HOME/.bun" ]; then
    curl -fsSL https://bun.sh/install | bash
    echo -e "  ${GREEN}✓${NC} Bun installed"
else
    echo -e "  ${GREEN}✓${NC} Bun already installed"
fi

# ============================================================================
# Post-Install: Clone Required Projects
# ============================================================================

echo ""
echo -e "${YELLOW}📁 Cloning required projects...${NC}"
"$DOTFILES_DIR/scripts/clone_projects.sh"

# ============================================================================
# Post-Install: Set Default Shell
# ============================================================================

echo ""
echo -e "${YELLOW}🐟 Setting up fish shell...${NC}"
"$DOTFILES_DIR/scripts/set_default_shell.sh"

# ============================================================================
# Done
# ============================================================================

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Installation complete!                 ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo "Next steps:"
echo "  1. Run: ~/dotfiles/link.sh"
echo "  2. Run: ~/dotfiles/scripts/restore_systemd_services.sh"
echo "  3. Log out and back in (for fish shell)"
echo "  4. Reboot"
