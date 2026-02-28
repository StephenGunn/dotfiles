"""
Piantor Pro 36 Layout Definition

The layout maps evdev key names to positions on the keyboard.
Customize KEY_NAMES to match your actual keymap.
"""

# Display names for keys (evdev name -> display)
# Customize these to match your actual QMK keymap
KEY_NAMES = {
    # Letters
    "Q": "Q", "W": "W", "E": "E", "R": "R", "T": "T",
    "Y": "Y", "U": "U", "I": "I", "O": "O", "P": "P",
    "A": "A", "S": "S", "D": "D", "F": "F", "G": "G",
    "H": "H", "J": "J", "K": "K", "L": "L",
    "Z": "Z", "X": "X", "C": "C", "V": "V", "B": "B",
    "N": "N", "M": "M",

    # Punctuation
    "SEMICOLON": ";",
    "APOSTROPHE": "'",
    "COMMA": ",",
    "DOT": ".",
    "SLASH": "/",
    "BACKSLASH": "\\",
    "LEFTBRACE": "[",
    "RIGHTBRACE": "]",
    "MINUS": "-",
    "EQUAL": "=",
    "GRAVE": "`",

    # Modifiers
    "LEFTSHIFT": "SFT",
    "RIGHTSHIFT": "SFT",
    "LEFTCTRL": "CTL",
    "RIGHTCTRL": "CTL",
    "LEFTALT": "ALT",
    "RIGHTALT": "ALT",
    "LEFTMETA": "GUI",
    "RIGHTMETA": "GUI",

    # Thumb keys
    "BACKSPACE": "BSP",
    "SPACE": "SPC",
    "ENTER": "RET",
    "DELETE": "DEL",
    "TAB": "TAB",
    "ESC": "ESC",
    "ESCAPE": "ESC",

    # Navigation
    "LEFT": "←",
    "RIGHT": "→",
    "UP": "↑",
    "DOWN": "↓",
    "HOME": "HOM",
    "END": "END",
    "PAGEUP": "PGU",
    "PAGEDOWN": "PGD",

    # Numbers
    "1": "1", "2": "2", "3": "3", "4": "4", "5": "5",
    "6": "6", "7": "7", "8": "8", "9": "9", "0": "0",

    # Function keys
    "F1": "F1", "F2": "F2", "F3": "F3", "F4": "F4",
    "F5": "F5", "F6": "F6", "F7": "F7", "F8": "F8",
    "F9": "F9", "F10": "F10", "F11": "F11", "F12": "F12",

    # Media
    "VOLUMEUP": "V+",
    "VOLUMEDOWN": "V-",
    "MUTE": "MUT",
    "PLAYPAUSE": "▶",
    "NEXTSONG": ">>",
    "PREVIOUSSONG": "<<",

    # Misc
    "CAPSLOCK": "CAP",
    "PRINT": "PRT",
    "SCROLLLOCK": "SCR",
    "PAUSE": "PAU",
    "INSERT": "INS",
}

# Piantor Pro 36 physical layout
# Each row has left and right halves
# Keys are evdev names that will be matched against pressed keys
PIANTOR_PRO_36 = {
    "name": "Piantor Pro 36",
    "rows": [
        {
            "left": ["Q", "W", "E", "R", "T"],
            "right": ["Y", "U", "I", "O", "P"],
        },
        {
            "left": ["A", "S", "D", "F", "G"],
            "right": ["H", "J", "K", "L", "SEMICOLON"],
        },
        {
            "left": ["Z", "X", "C", "V", "B"],
            "right": ["N", "M", "COMMA", "DOT", "SLASH"],
        },
    ],
    "thumbs": {
        # Customize these to match your thumb cluster mapping
        "left": ["ESC", "BACKSPACE", "SPACE"],
        "right": ["ENTER", "DELETE", "TAB"],
    },
}

# Alternative layouts can be defined here
# For example, if you have a different thumb cluster arrangement:

COLEMAK_DH = {
    "name": "Colemak-DH",
    "rows": [
        {
            "left": ["Q", "W", "F", "P", "B"],
            "right": ["J", "L", "U", "Y", "SEMICOLON"],
        },
        {
            "left": ["A", "R", "S", "T", "G"],
            "right": ["M", "N", "E", "I", "O"],
        },
        {
            "left": ["Z", "X", "C", "D", "V"],
            "right": ["K", "H", "COMMA", "DOT", "SLASH"],
        },
    ],
    "thumbs": {
        "left": ["ESC", "SPACE", "TAB"],
        "right": ["ENTER", "BACKSPACE", "DELETE"],
    },
}
