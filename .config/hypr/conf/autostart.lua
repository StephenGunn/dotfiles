-- Autostart applications

hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sh .config/hypr/desktop-portals.sh")
    hl.exec_cmd("sh .config/hypr/per-monitor-launcher.sh")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("dunst")
    hl.exec_cmd("systemctl --user restart libinput-gestures")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 28")
    hl.exec_cmd("~/dotfiles/scripts/hypr-theme-init.sh 2>> /tmp/hypr-theme-init.log")
    hl.exec_cmd("pypr --debug /tmp/pypr.log")
    hl.exec_cmd("wl-paste --watch cliphist store")
end)

-- These run on every config reload, not just startup
hl.on("config.reloaded", function()
    hl.exec_cmd("sh .config/hypr/scripts/get-last-focused-window.sh")
    hl.exec_cmd("eww daemon")
end)
