-- Host: surfarch (Surface Pro 8 tablet)
-- Single high-DPI touchscreen

hl.monitor({ output = "eDP-1", mode = "2880x1920@120", position = "0x0", scale = "1.5" })

for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", default = true })
end
