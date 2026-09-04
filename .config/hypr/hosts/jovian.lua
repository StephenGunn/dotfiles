-- Host: jovian (desktop)
-- Triple monitor: vertical (left) + main (center) + tiny (right)

-- Monitors
hl.monitor({ output = "DP-3",     mode = "2560x1440@143",   position = "-1440x-510", scale = "1", transform = 1 })
hl.monitor({ output = "DP-2",     mode = "2560x1440@165",   position = "0x0",        scale = "1" })
hl.monitor({ output = "HDMI-A-1", mode = "1280x800@59.81",  position = "2560x640",   scale = "1" })

-- Vertical monitor (DP-3, left) - Workspaces 1-5
for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-3", default = true })
end

-- Main monitor (DP-2, center) - Workspaces 6-10
for i = 6, 10 do
    local opts = { workspace = tostring(i), monitor = "DP-2", default = true }
    if i == 10 then opts.layout = "scrolling" end
    hl.workspace_rule(opts)
end

-- Tiny monitor (HDMI-A-1, right) - Workspaces 11-12
for i = 11, 12 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", default = true })
end

-- Astroterm star map on tiny monitor
hl.on("hyprland.start", function()
    hl.exec_cmd('ghostty --title=tiny-monitor-app -e fish -c \'astroterm --city "Kansas City" --color -u\'')
end)
