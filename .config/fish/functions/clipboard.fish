# ============================================================================
# CLIPBOARD FUNCTIONS - SSH & OSC 52 Support
# ============================================================================
# These functions provide clipboard access that works over SSH connections
# using OSC 52 escape sequences that work through terminal emulators
# ============================================================================

# ----------------------------------------------------------------------------
# clip - Copy to clipboard using OSC 52 (works over SSH)
# ----------------------------------------------------------------------------
# Usage:
#   echo "text" | clip          # Copy from stdin
#   clip "some text"            # Copy from argument
#   cat file.txt | clip         # Copy file contents
# ----------------------------------------------------------------------------
function clip --description "Copy to clipboard using OSC 52 (works over SSH)"
    if test (count $argv) -eq 0
        # Read from stdin
        set content (cat)
    else
        # Use arguments as content
        set content $argv
    end

    # Send OSC 52 sequence to terminal
    # Format: \033]52;c;<base64-encoded-text>\a
    printf "\033]52;c;%s\a" (printf "%s" $content | base64 | tr -d '\n')
end

# ----------------------------------------------------------------------------
# paste - Paste from system clipboard (Wayland - local only)
# ----------------------------------------------------------------------------
# Usage:
#   paste                       # Output clipboard contents
#   paste > file.txt            # Save to file
# ----------------------------------------------------------------------------
function paste --description "Paste from system clipboard (Wayland)"
    wl-paste
end

# ----------------------------------------------------------------------------
# copy - Copy to system clipboard (Wayland - local only)
# ----------------------------------------------------------------------------
# Usage:
#   echo "text" | copy          # Copy from stdin
#   cat file.txt | copy         # Copy file contents
# ----------------------------------------------------------------------------
function copy --description "Copy to system clipboard (Wayland)"
    wl-copy
end

# ----------------------------------------------------------------------------
# clipfile - Copy entire file to clipboard via OSC 52
# ----------------------------------------------------------------------------
# Usage:
#   clipfile myfile.txt         # Copy file contents over SSH
# ----------------------------------------------------------------------------
function clipfile --description "Copy file contents to clipboard using OSC 52"
    if test (count $argv) -eq 0
        echo "Usage: clipfile <filename>"
        return 1
    end

    if not test -f $argv[1]
        echo "Error: File '$argv[1]' not found"
        return 1
    end

    cat $argv[1] | clip
    echo "✓ Copied $argv[1] to clipboard"
end
