-- Keybindings

local mainMod = "SUPER"

-- Programs
local terminal = "ghostty"
local fileManager = "thunar"
local menu = 'rofi -show drun -p ">"'

-----------
-- Apps  --
-----------

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))

-----------
-- System --
-----------

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("~/.local/bin/theme-switch"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd('cliphist list | rofi -dmenu -p "\xf3\xb0\x85\x87" -display-columns 2 | cliphist decode | wl-copy'))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("rofi -show emoji -modi emoji"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("rofi-power-menu"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("~/dotfiles/scripts/cmatrix-screensaver.sh"))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("~/dotfiles/scripts/show-keymap.sh"))

-- Panel controls
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("pkill -x quickshell; sleep 0.3 && quickshell &"))

-- Streaming
hl.bind(mainMod .. " + ALT + CTRL + N", hl.dsp.exec_cmd("~/dotfiles/scripts/streaming-blur.sh toggle"))

-------------
-- Windows --
-------------

hl.bind(mainMod .. " + ALT + backspace", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + N", hl.dsp.layout("togglesplit"))

-- Move focus with CTRL + vim keys
local directions = { h = "left", l = "right", k = "up", j = "down" }
for key, dir in pairs(directions) do
    hl.bind("CTRL + " .. key, hl.dsp.focus({ direction = dir }))
end

-- Resize windows with mainMod + arrow keys
hl.bind(mainMod .. " + right", hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }))
hl.bind(mainMod .. " + left",  hl.dsp.window.resize({ x = -50, y = 0,   relative = true }))
hl.bind(mainMod .. " + up",    hl.dsp.window.resize({ x = 0,   y = -50, relative = true }))
hl.bind(mainMod .. " + down",  hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }))

-- Move windows with SUPER SHIFT + vim keys
local move_dirs = { H = "l", L = "r", K = "u", J = "d" }
for key, dir in pairs(move_dirs) do
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

----------------
-- Workspaces --
----------------

-- Left hand (QWERT) = left monitor ws 1-5, right hand (YUIOP) = main monitor ws 6-10
local top_row = { "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P" }
for i, key in ipairs(top_row) do
    hl.bind(mainMod .. " + ALT + " .. key,          hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + ALT + CTRL + " .. key,   hl.dsp.window.move({ workspace = i }))
end

-- Tiny monitor (MEH + right hand home row)
hl.bind("CTRL + SHIFT + ALT + H", hl.dsp.focus({ workspace = 11 }))
hl.bind("CTRL + SHIFT + ALT + J", hl.dsp.focus({ workspace = 12 }))
hl.bind("CTRL + SHIFT + ALT + K", hl.dsp.window.move({ workspace = 11 }))
hl.bind("CTRL + SHIFT + ALT + L", hl.dsp.window.move({ workspace = 12 }))

----------------
-- Scratchpads --
----------------

hl.bind(mainMod .. " + S",         hl.dsp.exec_cmd("~/dotfiles/scripts/toggle-scratchpad.sh"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.workspace.toggle_special("browser"))
hl.bind(mainMod .. " + D",         hl.dsp.exec_cmd("~/.config/hypr/scripts/dotfiles-workspace.sh"))
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd("~/projects/theme-switcher/scripts/random-wallpaper"))

-----------
-- Media --
-----------

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute",       hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioPlay",       hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioStop",       hl.dsp.exec_cmd("playerctl stop"))

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +10%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"))
hl.bind(mainMod .. " + H",      hl.dsp.exec_cmd("~/dotfiles/scripts/rofi-brightness.sh"))

-----------------
-- Screenshots --
-----------------

hl.bind("Print",          hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SUPER + Print",  hl.dsp.exec_cmd("~/dotfiles/scripts/screenshot-save.sh"))

--------------
-- Pyprland --
--------------

hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("pypr zoom ++0.5"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pypr zoom"))

-----------------------------
-- Scrolling layout (MEH) --
-----------------------------

local scroll_binds = {
    Q = "togglefit",
    W = "move -col",
    E = "promote",
    R = "move +col",
    T = "swapcol l",
    G = "colresize +conf",
    B = "colresize -conf",
}
for key, msg in pairs(scroll_binds) do
    hl.bind("CTRL + SHIFT + ALT + " .. key, hl.dsp.layout(msg))
end

---------------
-- Streaming --
---------------

hl.bind(mainMod .. " + comma",          hl.dsp.exec_cmd("~/dotfiles/scripts/rofi-streaming.sh"))
hl.bind(mainMod .. " + G",              hl.dsp.exec_cmd("~/dotfiles/scripts/rofi-vm.sh"))
hl.bind(mainMod .. " + SHIFT + comma",  hl.dsp.exec_cmd("~/dotfiles/scripts/webcam-expand.sh face"))
hl.bind(mainMod .. " + CTRL + comma",   hl.dsp.exec_cmd("~/dotfiles/scripts/webcam-expand.sh topdown"))
