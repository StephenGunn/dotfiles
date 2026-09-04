-- Host: titan (HP OMEN MAX 16" gaming laptop)
-- Single 16:10 high-refresh display

hl.monitor({ output = "eDP-1", mode = "2560x1600@240", position = "0x0", scale = "1" })

for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", default = true })
end
