#!/usr/bin/env python3
"""
Keyviz - TUI Keyboard Visualizer for Piantor Pro 36
"""

import asyncio
from collections import deque
from datetime import datetime

import evdev
from evdev import ecodes
from textual.app import App, ComposeResult
from textual.containers import Container, Horizontal, Vertical
from textual.reactive import reactive
from textual.widgets import Static, Footer
from textual.binding import Binding

from layout import PIANTOR_PRO_36, KEY_NAMES


class KeyboardDisplay(Static):
    """Renders the keyboard layout with pressed keys highlighted."""

    pressed_keys: reactive[set] = reactive(set, always_update=True)

    def render(self) -> str:
        layout = PIANTOR_PRO_36
        lines = []

        # Build each row
        for row_idx, row in enumerate(layout["rows"]):
            left = row["left"]
            right = row["right"]

            # Top border for first row
            if row_idx == 0:
                lines.append(self._build_border(left, right, "top"))

            # Key labels
            lines.append(self._build_key_row(left, right))

            # Bottom border / separator
            if row_idx < len(layout["rows"]) - 1:
                lines.append(self._build_border(left, right, "mid"))
            else:
                # Before thumbs, close the main grid
                lines.append(self._build_border(left, right, "bot"))

        # Thumb cluster
        thumbs = layout["thumbs"]
        lines.append(self._build_thumb_row(thumbs["left"], thumbs["right"]))

        return "\n".join(lines)

    def _build_border(self, left: list, right: list, pos: str) -> str:
        chars = {
            "top": ("╭", "┬", "╮", "───"),
            "mid": ("├", "┼", "┤", "───"),
            "bot": ("╰", "┴", "╯", "───"),
        }
        l, m, r, h = chars[pos]

        left_part = l + m.join([h] * len(left)) + r
        right_part = l + m.join([h] * len(right)) + r

        gap = "     "
        return f"  {left_part}{gap}{right_part}"

    def _build_key_row(self, left: list, right: list) -> str:
        left_keys = "│" + "│".join(self._format_key(k) for k in left) + "│"
        right_keys = "│" + "│".join(self._format_key(k) for k in right) + "│"
        gap = "     "
        return f"  {left_keys}{gap}{right_keys}"

    def _build_thumb_row(self, left: list, right: list) -> str:
        # Thumbs are offset/centered
        left_keys = "│" + "│".join(self._format_key(k) for k in left) + "│"
        right_keys = "│" + "│".join(self._format_key(k) for k in right) + "│"

        # Build borders
        top_l = "        ╭" + "┬".join(["───"] * len(left)) + "╮"
        top_r = "╭" + "┬".join(["───"] * len(right)) + "╮"
        key_l = "        " + left_keys
        key_r = right_keys
        bot_l = "        ╰" + "┴".join(["───"] * len(left)) + "╯"
        bot_r = "╰" + "┴".join(["───"] * len(right)) + "╯"

        gap = " "
        return f"{top_l}{gap}{top_r}\n{key_l}{gap}{key_r}\n{bot_l}{gap}{bot_r}"

    def _format_key(self, keycode: str) -> str:
        """Format a key, highlighting if pressed."""
        display = KEY_NAMES.get(keycode, keycode)[:3].center(3)

        if keycode in self.pressed_keys:
            return f"[reverse bold]{display}[/]"
        return display


class InputStream(Static):
    """Shows a stream of recent keypresses."""

    max_items = 12
    items: reactive[deque] = reactive(lambda: deque(maxlen=12), always_update=True)

    def render(self) -> str:
        lines = ["[bold]Input Stream[/]", "─" * 30]

        if not self.items:
            lines.append("[dim]Waiting for input...[/]")
        else:
            for item in reversed(self.items):
                lines.append(item)

        # Pad to fixed height
        while len(lines) < self.max_items + 2:
            lines.append("")

        return "\n".join(lines)

    def add_event(self, key: str, action: str, timestamp: datetime):
        time_str = timestamp.strftime("%H:%M:%S")
        symbol = "▼" if action == "down" else "▲"
        color = "green" if action == "down" else "red"
        display_name = KEY_NAMES.get(key, key)

        entry = f"[dim]{time_str}[/] [{color}]{symbol}[/] {display_name}"

        new_items = deque(self.items, maxlen=self.max_items)
        new_items.append(entry)
        self.items = new_items


class LayerIndicator(Static):
    """Shows current layer (placeholder for HID integration)."""

    layer: reactive[str] = reactive("BASE")

    def render(self) -> str:
        return f"[bold]Layer:[/] [cyan]{self.layer}[/]"


class ModifierIndicator(Static):
    """Shows active modifiers."""

    mods: reactive[set] = reactive(set, always_update=True)

    MODIFIER_KEYS = {"LSFT", "RSFT", "LCTL", "RCTL", "LALT", "RALT", "LGUI", "RGUI"}

    def render(self) -> str:
        mod_display = []
        for mod in ["SFT", "CTL", "ALT", "GUI"]:
            active = any(m.endswith(mod) or m.endswith(mod.lower()) for m in self.mods)
            if active:
                mod_display.append(f"[bold green]{mod}[/]")
            else:
                mod_display.append(f"[dim]{mod}[/]")

        return "[bold]Mods:[/] " + " ".join(mod_display)


class KeyvizApp(App):
    """Main Keyviz application."""

    CSS = """
    Screen {
        layout: horizontal;
    }

    #keyboard-container {
        width: 60%;
        height: 100%;
        padding: 1;
    }

    #sidebar {
        width: 40%;
        height: 100%;
        padding: 1;
        border-left: solid $primary;
    }

    #status-bar {
        height: 3;
        dock: bottom;
        padding: 0 1;
    }

    KeyboardDisplay {
        height: auto;
    }

    InputStream {
        height: 100%;
    }

    LayerIndicator, ModifierIndicator {
        height: 1;
    }
    """

    BINDINGS = [
        Binding("q", "quit", "Quit"),
        Binding("c", "clear", "Clear"),
    ]

    def __init__(self, device_path: str | None = None):
        super().__init__()
        self.device_path = device_path
        self.device = None

    def compose(self) -> ComposeResult:
        with Horizontal():
            with Container(id="keyboard-container"):
                yield KeyboardDisplay()
                with Horizontal(id="status-bar"):
                    yield LayerIndicator()
                    yield ModifierIndicator()
            with Container(id="sidebar"):
                yield InputStream()
        yield Footer()

    async def on_mount(self) -> None:
        """Start the input reader when app mounts."""
        if self.device_path:
            self.run_worker(self.read_input(), exclusive=True)
        else:
            self.notify("No device specified. Use --device or --list", severity="warning")

    async def read_input(self) -> None:
        """Read input events from evdev device."""
        try:
            self.device = evdev.InputDevice(self.device_path)
            self.notify(f"Connected: {self.device.name}", severity="information")

            async for event in self.device.async_read_loop():
                if event.type == ecodes.EV_KEY:
                    await self.handle_key_event(event)

        except FileNotFoundError:
            self.notify(f"Device not found: {self.device_path}", severity="error")
        except PermissionError:
            self.notify(f"Permission denied: {self.device_path}\nTry: sudo usermod -aG input $USER", severity="error")
        except Exception as e:
            self.notify(f"Error: {e}", severity="error")

    async def handle_key_event(self, event) -> None:
        """Process a key event."""
        key_name = ecodes.KEY.get(event.code, f"KEY_{event.code}")
        if isinstance(key_name, list):
            key_name = key_name[0]

        # Remove KEY_ prefix
        key_name = key_name.replace("KEY_", "")

        keyboard = self.query_one(KeyboardDisplay)
        stream = self.query_one(InputStream)
        mods = self.query_one(ModifierIndicator)

        if event.value == 1:  # Key down
            new_pressed = set(keyboard.pressed_keys)
            new_pressed.add(key_name)
            keyboard.pressed_keys = new_pressed

            # Track modifiers
            if key_name in ["LEFTSHIFT", "RIGHTSHIFT", "LEFTCTRL", "RIGHTCTRL",
                           "LEFTALT", "RIGHTALT", "LEFTMETA", "RIGHTMETA"]:
                new_mods = set(mods.mods)
                new_mods.add(key_name)
                mods.mods = new_mods

            stream.add_event(key_name, "down", datetime.now())

        elif event.value == 0:  # Key up
            new_pressed = set(keyboard.pressed_keys)
            new_pressed.discard(key_name)
            keyboard.pressed_keys = new_pressed

            # Untrack modifiers
            if key_name in ["LEFTSHIFT", "RIGHTSHIFT", "LEFTCTRL", "RIGHTCTRL",
                           "LEFTALT", "RIGHTALT", "LEFTMETA", "RIGHTMETA"]:
                new_mods = set(mods.mods)
                new_mods.discard(key_name)
                mods.mods = new_mods

            stream.add_event(key_name, "up", datetime.now())

    def action_clear(self) -> None:
        """Clear the input stream."""
        stream = self.query_one(InputStream)
        stream.items = deque(maxlen=stream.max_items)
        keyboard = self.query_one(KeyboardDisplay)
        keyboard.pressed_keys = set()


def list_devices():
    """List available input devices."""
    devices = [evdev.InputDevice(path) for path in evdev.list_devices()]
    print("\nAvailable input devices:\n")
    for d in devices:
        caps = d.capabilities(verbose=True)
        has_keys = any("EV_KEY" in str(c) for c in caps)
        marker = " [keyboard]" if has_keys else ""
        print(f"  {d.path}: {d.name}{marker}")
    print()


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Keyviz - TUI Keyboard Visualizer")
    parser.add_argument("--device", "-d", help="Input device path (e.g., /dev/input/event0)")
    parser.add_argument("--list", "-l", action="store_true", help="List available input devices")
    args = parser.parse_args()

    if args.list:
        list_devices()
        return

    app = KeyvizApp(device_path=args.device)
    app.run()


if __name__ == "__main__":
    main()
