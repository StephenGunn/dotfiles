-- Streaming mode workspace gaps
-- streaming-mode.sh writes streaming.conf in hyprlang format.
-- Parse it and apply workspace gap overrides via hyprctl keyword.
-- The streaming.conf file is still sourced by hyprland.conf (kept as
-- fallback), but when running Lua config this module handles it.

local conf = os.getenv("HOME") .. "/.config/hypr/streaming.conf"
local f = io.open(conf, "r")
if f then
    for line in f:lines() do
        -- Match lines like: workspace = 1, monitor:DP-2, gapsout:15 470 15 15
        local ws_args = line:match("^workspace%s*=%s*(.+)$")
        if ws_args then
            hl.keyword("workspace " .. ws_args)
        end
    end
    f:close()
end
