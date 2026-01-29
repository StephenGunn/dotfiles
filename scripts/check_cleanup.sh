#!/bin/bash

# Packages that have been intentionally removed or replaced
# Add packages here when you stop using them
REMOVED_PACKAGES=(
    "abduco"
    "wofi"              # replaced by rofi
    "grimblast-git"     # not needed
    "hyprsunset-git"    # not needed
    "waypaper"          # not needed
    "nodejs"            # using bun instead
    "npm"               # using bun instead
    "qt5ct"             # not needed
    "qt6ct"             # not needed
    "breeze-icons"      # not needed
)

# Packages replaced by alternatives (old -> new)
REPLACED_PACKAGES=(
    "python-pywal:python-pywal16"
    "aylurs-gtk-shell-git:ags-hyprpanel-git"
    "bibata-cursor-theme:bibata-cursor-theme-bin"
)

echo "=== Checking for packages that should be removed ==="
echo ""

found_any=false

echo "Removed packages still installed:"
echo "---------------------------------"
for pkg in "${REMOVED_PACKAGES[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
        echo "  ✗ $pkg is still installed"
        found_any=true
    fi
done

echo ""
echo "Replaced packages (old version still installed):"
echo "-------------------------------------------------"
for pair in "${REPLACED_PACKAGES[@]}"; do
    old_pkg="${pair%%:*}"
    new_pkg="${pair##*:}"
    if pacman -Qi "$old_pkg" &>/dev/null; then
        echo "  ✗ $old_pkg is installed (replaced by $new_pkg)"
        found_any=true
    fi
done

echo ""
if [ "$found_any" = false ]; then
    echo "✓ No removed packages found - all clean!"
else
    echo "To remove a package: sudo pacman -Rns <package>"
    echo "To remove an AUR package: yay -Rns <package>"
fi
