-- Look and feel: env vars, animations, general/decoration/layout config

local C = require("conf.colors")

-- Environment variables
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- Animation curves
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },      { 1, 1 } } })
hl.curve("md3_standard",   { type = "bezier", points = { { 0.2, 0 },    { 0, 1 } } })
hl.curve("md3_decel",      { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("md3_accel",      { type = "bezier", points = { { 0.3, 0 },    { 0.8, 0.15 } } })
hl.curve("overshot",       { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.1 } } })
hl.curve("crazyshot",      { type = "bezier", points = { { 0.1, 1.5 },  { 0.76, 0.92 } } })
hl.curve("hyprnostretch",  { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })
hl.curve("fluent_decel",   { type = "bezier", points = { { 0.1, 1 },    { 0, 1 } } })
hl.curve("easeInOutCirc",  { type = "bezier", points = { { 0.85, 0 },   { 0.15, 1 } } })
hl.curve("easeOutCirc",    { type = "bezier", points = { { 0, 0.55 },   { 0.45, 1 } } })
hl.curve("easeOutExpo",    { type = "bezier", points = { { 0.16, 1 },   { 0.3, 1 } } })
hl.curve("softBounce",     { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.02 } } })
hl.curve("popBounce",      { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

-- Animations
hl.animation({ leaf = "windows",          enabled = true, speed = 3,  bezier = "softBounce", style = "slide" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 3,  bezier = "softBounce" })
hl.animation({ leaf = "border",           enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",             enabled = true, speed = 3,  bezier = "md3_decel" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 4,  bezier = "softBounce", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4,  bezier = "softBounce", style = "slidefadevert 30%" })

-- Main config
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
    cursor = {
        no_hardware_cursors = true,
    },
    general = {
        gaps_in = 9,
        gaps_out = 15,
        border_size = 2,
        col = {
            active_border = C.teal,
            inactive_border = C.surface2,
        },
        resize_on_border = false,
        extend_border_grab_area = 15,
        hover_icon_on_border = true,
        allow_tearing = false,
    },
    decoration = {
        rounding = 5,
        active_opacity = 1.0,
        inactive_opacity = 0.9,
        shadow = {
            enabled = true,
            range = 3,
            render_power = 1,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 10,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
    master = {
        new_status = "master",
    },
    scrolling = {
        column_width = 0.9,
        explicit_column_widths = "0.25, 0.5, 0.75, 0.9, 1.0",
        focus_fit_method = 0,
        fullscreen_on_one_column = true,
        follow_focus = true,
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
        focus_on_activate = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})
