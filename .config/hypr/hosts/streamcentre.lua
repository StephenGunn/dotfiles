-- Host: streamcentre (streaming box)
-- Single HDMI display

hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@60", position = "0x0", scale = "1.5" })

for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-2", default = true })
end
