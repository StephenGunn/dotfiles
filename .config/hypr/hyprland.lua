-- Hyprland Lua Configuration
-- Migrated from hyprlang (.conf) — original files kept as reference.
-- Hyprland 0.55+ loads this file automatically when present.

-- Plugins
if os.getenv("HYPR_NO_PLUGINS") ~= "1" then
    hl.plugin.load(
        os.getenv("HOME") .. "/.local/lib/hyprland-plugins/glasscope/glasscope.so"
    )
end

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

-- Streaming mode gap overrides (loads streaming_gen.lua)
require("conf.streaming")

-- Glasscope plugin configuration
if os.getenv("HYPR_NO_PLUGINS") ~= "1" and hl.plugin.glasscope ~= nil then
    hl.config({
        plugin = {
            glasscope = {
                enabled = true,
                radius = 228,
                edge_width = 22.0,
                zoom = 2.0,
                bulge = 0.08,
                refraction = 1.0,
                dispersion = 0.7,
                edge_strength = 1.25,
                motion_strength = 1.5,
                nearest = false,
                color_strength = 0.3,
                color_width = 18.0,
                colors = {
                    transmission = "rgba(ffb8740d)",
                    refraction = "rgba(afd428a6)",
                    reflection = "rgba(f77a9599)",
                    highlight = "rgba(efe0d580)",
                },
            },
        },
    })
end

-- Autostart applications
require("conf.autostart")
