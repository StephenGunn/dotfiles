#!/usr/bin/env bash

# Sync GTK bookmarks to Qt/KDE format (ONE-WAY SYNC)
#
# Source of Truth: Thunar (GTK Bookmarks)
# Sync Direction:  ~/.config/gtk-3.0/bookmarks → ~/.local/share/user-places.xbel
#
# This is a one-way sync from GTK to Qt. Manage your bookmarks in Thunar,
# then run this script to update Qt apps (Dolphin, KDE apps).
#
# DO NOT edit Qt bookmarks directly - they will be overwritten!

set -e

GTK_BOOKMARKS="$HOME/.config/gtk-3.0/bookmarks"
QT_BOOKMARKS="$HOME/.local/share/user-places.xbel"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if GTK bookmarks exist
if [ ! -f "$GTK_BOOKMARKS" ]; then
    log_warn "GTK bookmarks file not found: $GTK_BOOKMARKS"
    log_info "Creating default GTK bookmarks..."
    mkdir -p "$(dirname "$GTK_BOOKMARKS")"
    cat > "$GTK_BOOKMARKS" <<EOF
file://$HOME/Downloads Downloads
file://$HOME/Documents Documents
file://$HOME/projects Projects
EOF
    log_success "Created default GTK bookmarks"
fi

log_info "Syncing GTK bookmarks to Qt format..."

# Create Qt bookmarks directory
mkdir -p "$(dirname "$QT_BOOKMARKS")"

# Start XML file
cat > "$QT_BOOKMARKS" <<'XMLHEADER'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xbel>
<xbel xmlns:bookmark="http://www.freedesktop.org/standards/bookmark" xmlns:kdepriv="http://www.kde.org/kdepriv" xmlns:mime="http://www.freedesktop.org/standards/shared-mime-info">
XMLHEADER

# Parse GTK bookmarks and convert to XML
bookmark_count=0
while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # Parse bookmark line
    # Format: file:///path/to/folder Optional Label
    if [[ "$line" =~ ^file://(.+)$ ]]; then
        full_line="${BASH_REMATCH[1]}"

        # Split path and label
        path=$(echo "$full_line" | awk '{print $1}')
        label=$(echo "$full_line" | cut -d' ' -f2-)

        # If no label, use basename of path
        if [ "$path" = "$label" ]; then
            label=$(basename "$path")
        fi

        # Add to XML
        cat >> "$QT_BOOKMARKS" <<BOOKMARK
 <bookmark href="file://$path">
  <title>$label</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="folder"/>
   </metadata>
  </info>
 </bookmark>
BOOKMARK

        bookmark_count=$((bookmark_count + 1))
    fi
done < "$GTK_BOOKMARKS"

# Close XML file
echo "</xbel>" >> "$QT_BOOKMARKS"

log_success "Synced $bookmark_count bookmarks to Qt format"
log_info "GTK bookmarks: $GTK_BOOKMARKS"
log_info "Qt bookmarks:  $QT_BOOKMARKS"

echo ""
log_info "Bookmarks are now synced!"
log_info "  • GTK apps (Thunar, file dialogs): Use GTK bookmarks automatically"
log_info "  • Qt apps (Dolphin, KDE apps): Use Qt bookmarks automatically"
log_info ""
log_info "To add new bookmarks:"
log_info "  1. Edit $GTK_BOOKMARKS"
log_info "  2. Run this script again to sync"
log_info "  OR"
log_info "  Add via Thunar: Navigate to folder, press Ctrl+D"
