-- Window rules and workspace rules

--------------
-- Privacy  --
--------------

hl.window_rule({
    name = "privacy-blur-border",
    match = { tag = "privacy-blur" },
    border_color = "rgb(ff5555)",
})

--------------
-- General  --
--------------

-- Center floating windows (exclude apps with relative popups/menus)
hl.window_rule({
    name = "center-floating",
    match = {
        float = true,
        class = "^(?!zoom|krita|Krita|Gimp|gimp|inkscape|Inkscape|libreoffice|LibreOffice).*$",
    },
    center = true,
})

hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-----------------
-- Scratchpads --
-----------------

-- Scratchpad workspace rules
hl.workspace_rule({ workspace = "special:magic",    ["on-created-empty"] = "ghostty",  persistent = false })
hl.workspace_rule({ workspace = "special:browser",  ["on-created-empty"] = "firefox",  persistent = false })
hl.workspace_rule({ workspace = "special:wallpaper", persistent = false })
hl.workspace_rule({ workspace = "special:dotfiles",  persistent = false })

-- Scratchpad window rules (ghostty + firefox + dotfiles share similar sizing)
hl.window_rule({
    name = "ghostty-scratchpad",
    match = { class = "^(com\\.mitchellh\\.ghostty)$", workspace = "special:magic" },
    float = true,
    size = "(monitor_w*0.75) (monitor_h*0.86)",
    move = "(monitor_w*0.125) (monitor_h*0.07)",
    persistent_size = false,
})

hl.window_rule({
    name = "firefox-browser-scratchpad",
    match = { class = "^(firefox)$", workspace = "special:browser" },
    float = true,
    size = "(monitor_w*0.75) (monitor_h*0.86)",
    center = true,
    persistent_size = false,
})

hl.window_rule({
    name = "dotfiles-scratchpad",
    match = { class = "^(com\\.mitchellh\\.ghostty)$", workspace = "special:dotfiles" },
    float = true,
    size = "(monitor_w*0.75) (monitor_h*0.86)",
    center = true,
    persistent_size = false,
})

--------------
-- CMatrix  --
--------------

hl.window_rule({
    name = "cmatrix-1-fullscreen",
    match = { class = "^(cmatrix-1)$" },
    fullscreen = true, monitor = "0",
})

hl.window_rule({
    name = "cmatrix-2-fullscreen",
    match = { class = "^(cmatrix-2)$" },
    fullscreen = true, monitor = "1",
})

----------------
-- Streaming  --
----------------

-- Webcam face - top position in sidebar (16:9 aspect)
-- X: 2560 - 20 (gaps_out) - 430 (width) = 2110
-- Y: 47 (panel) + 20 (gaps_out) = 67
hl.window_rule({
    name = "streaming-webcam-face",
    match = { title = "^(webcam-face)$" },
    float = true, pin = true, monitor = "0",
    move = "2110 68", size = "430 242", no_focus = true,
})

-- Webcam topdown - below face cam
-- Y: 70 + 242 + 20 (gutter) = 332
hl.window_rule({
    name = "streaming-webcam-topdown",
    match = { title = "^(webcam-topdown)$" },
    float = true, pin = true, monitor = "0",
    move = "2110 332", size = "430 242", no_focus = true,
})

-- Screenkey
hl.window_rule({
    name = "streaming-screenkey",
    match = { class = "^(Screenkey)$" },
    float = true, pin = true, no_focus = true,
})

-- Streaming widgets - fill space under webcams
-- Y: 574 (bottom of topdown) + 20 (gap) = 594
-- Height: 1440 - 20 (bottom gap) - 594 = 826
for _, widget in ipairs({ "bonsai", "cmatrix", "cava", "pipes" }) do
    hl.window_rule({
        name = "streaming-" .. widget,
        match = { title = "^(streaming-" .. widget .. ")$" },
        float = true, pin = true, monitor = "0",
        move = "2110 594", size = "430 826", no_focus = true,
    })
end

-------------------
-- Tiny monitor  --
-------------------

hl.window_rule({
    name = "tiny-monitor-astroterm",
    match = { title = "^(tiny-monitor-app)$" },
    fullscreen = true, monitor = "HDMI-A-1",
})

-----------
-- VM/LG --
-----------

hl.window_rule({
    name = "looking-glass",
    match = { class = "^(looking-glass-client)$" },
    workspace = "4", fullscreen = true,
})

-----------
-- Keymap --
-----------

hl.window_rule({
    name = "keymap-viewer",
    match = { class = "^(imv)$" },
    float = true,
    size = "(monitor_w*0.80) (monitor_h*0.80)",
    center = true,
    persistent_size = false,
})
