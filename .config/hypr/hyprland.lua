-- Hyprland Lua Configuration
-- Migrated from hyprlang (.conf) — original files kept as reference.
-- Hyprland 0.55+ loads this file automatically when present.

-- Host-specific monitors and workspaces (detects hostname at runtime)
require("hosts.init")

-- Appearance: env vars, animations, general/decoration/layout
require("conf.appearance")

-- Input devices
require("conf.input")

-- Keybindings
require("conf.keybinds")

-- Window and workspace rules
require("conf.windowrules")

-- Streaming mode gap overrides (parsed from streaming.conf)
require("conf.streaming")

-- Autostart applications
require("conf.autostart")
