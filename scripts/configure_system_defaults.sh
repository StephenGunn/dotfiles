#!/usr/bin/env bash

# Configure System Default Applications
# Sets XDG MIME types and verifies theme configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_info "Configuring System Default Applications..."
echo ""

# Update mimeapps.list in dotfiles
MIMEAPPS="$HOME/dotfiles/.config/mimeapps.list"
mkdir -p "$(dirname "$MIMEAPPS")"

cat > "$MIMEAPPS" <<'EOF'
[Added Associations]
image/jpeg=org.kde.krita.desktop;
video/quicktime=vlc.desktop;
x-scheme-handler/chrome=waterfox.desktop;
x-scheme-handler/http=waterfox.desktop;
x-scheme-handler/https=waterfox.desktop;
inode/directory=org.kde.dolphin.desktop;

[Default Applications]
# Web Browser - Waterfox
application/x-extension-htm=waterfox.desktop
application/x-extension-html=waterfox.desktop
application/x-extension-shtml=waterfox.desktop
application/x-extension-xht=waterfox.desktop
application/x-extension-xhtml=waterfox.desktop
application/xhtml+xml=waterfox.desktop
text/html=waterfox.desktop
x-scheme-handler/about=waterfox.desktop
x-scheme-handler/chrome=waterfox.desktop
x-scheme-handler/http=waterfox.desktop
x-scheme-handler/https=waterfox.desktop
x-scheme-handler/unknown=waterfox.desktop

# File Manager - Dolphin
inode/directory=org.kde.dolphin.desktop

# Text Editor - Neovim
text/plain=nvim.desktop
text/x-shellscript=nvim.desktop
application/x-shellscript=nvim.desktop
text/x-python=nvim.desktop
text/x-markdown=nvim.desktop
application/json=nvim.desktop
text/x-lua=nvim.desktop

# Images - Krita
image/gif=org.kde.krita.desktop
image/jpeg=org.kde.krita.desktop
image/png=org.kde.krita.desktop

# Video - VLC
video/quicktime=vlc.desktop
video/mp4=vlc.desktop
video/x-matroska=vlc.desktop

# PDF
application/pdf=waterfox.desktop

# Email
x-scheme-handler/mailto=gmail-firefox.desktop
EOF

log_success "Created mimeapps.list in dotfiles"

# Copy to actual config location only if not already symlinked
if [ ! -L "$HOME/.config/mimeapps.list" ]; then
    cp "$MIMEAPPS" "$HOME/.config/mimeapps.list"
    log_success "Copied mimeapps.list to ~/.config/"
else
    log_success "mimeapps.list already symlinked from dotfiles"
fi

echo ""
log_info "Verifying XDG default applications..."

# Test defaults
echo ""
echo "Current default applications:"
echo "  File Manager: $(xdg-mime query default inode/directory)"
echo "  Web Browser (HTTP): $(xdg-mime query default x-scheme-handler/http)"
echo "  Web Browser (HTTPS): $(xdg-mime query default x-scheme-handler/https)"
echo "  Text Editor: $(xdg-mime query default text/plain)"
echo ""

# Verify Qt/Kvantum setup
log_info "Checking Qt/Kvantum configuration..."

if [ -f "$HOME/.config/Kvantum/kvantum.kvconfig" ]; then
    current_theme=$(grep '^theme=' "$HOME/.config/Kvantum/kvantum.kvconfig" | cut -d= -f2)
    log_success "Kvantum theme configured: $current_theme"
else
    log_warn "Kvantum config not found - will be created on next theme switch"
fi

# Check QT_STYLE_OVERRIDE in Hyprland config
if grep -q "env = QT_STYLE_OVERRIDE,kvantum" "$HOME/.config/hypr/hyprland.conf" 2>/dev/null; then
    log_success "QT_STYLE_OVERRIDE is set in Hyprland config"
else
    log_warn "QT_STYLE_OVERRIDE not found in Hyprland config"
    log_info "Add this line to hyprland.conf: env = QT_STYLE_OVERRIDE,kvantum"
fi

# Check for required packages
echo ""
log_info "Checking for required packages..."

packages_to_check=(
    "dolphin:File Manager"
    "kvantum:Qt Theme Engine"
    "ghostty:Terminal"
    "nvim:Text Editor"
)

missing_packages=()

for pkg_info in "${packages_to_check[@]}"; do
    pkg="${pkg_info%%:*}"
    desc="${pkg_info##*:}"

    if command -v "$pkg" &> /dev/null || pacman -Qq "$pkg" &> /dev/null 2>&1; then
        log_success "$desc ($pkg) is installed"
    else
        log_warn "$desc ($pkg) is NOT installed"
        missing_packages+=("$pkg")
    fi
done

if [ ${#missing_packages[@]} -gt 0 ]; then
    echo ""
    log_warn "Missing packages: ${missing_packages[*]}"
    log_info "Install with: sudo pacman -S ${missing_packages[*]}"
fi

# Check theme packages
echo ""
log_info "Checking theme packages..."

theme_packages=(
    "catppuccin-gtk-theme-mocha:Catppuccin GTK Theme"
    "breeze-icons:Breeze Icons"
    "bibata-cursor-theme:Bibata Cursor"
)

for pkg_info in "${theme_packages[@]}"; do
    pkg="${pkg_info%%:*}"
    desc="${pkg_info##*:}"

    if pacman -Qq "$pkg" &> /dev/null 2>&1; then
        log_success "$desc is installed"
    else
        log_warn "$desc is NOT installed (optional)"
    fi
done

echo ""
log_info "Kvantum theme packages (AUR):"
log_info "  - kvantum-theme-catppuccin-git"
log_info "  - kvantum-theme-gruvbox-git"
log_info "  Install with: yay -S kvantum-theme-catppuccin-git kvantum-theme-gruvbox-git"

echo ""
log_success "System defaults configuration complete!"
echo ""
log_info "Next steps:"
log_info "  1. Run './link.sh' to symlink the new mimeapps.list"
log_info "  2. Reload Hyprland or log out/in for Qt env vars to take effect"
log_info "  3. Run 'theme-switch' to apply a theme (will configure Kvantum)"
log_info "  4. Restart Dolphin: killall dolphin && dolphin &"
echo ""
log_info "See SYSTEM_DEFAULTS.md for more information"
