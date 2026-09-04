-- Input devices and per-device configs

hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
            disable_while_typing = true,
        },
    },
})

-- Per-device configs
hl.device({ name = "kensington-expert-mouse", sensitivity = -5 })
hl.device({ name = "logitech-g-pro--1",       sensitivity = -5 })
hl.device({ name = "beekeeb-piantor_pro-mouse", sensitivity = -0.5, accel_profile = "flat" })

-- Apple trackpads (USB-C and Bluetooth share identical settings)
for _, name in ipairs({
    "apple-inc.-magic-trackpad-usb-c",
    "apple-inc.-magic-trackpad",
}) do
    hl.device({
        name = name,
        natural_scroll = false,
        disable_while_typing = true,
        scroll_factor = 0.4,
        clickfinger_behavior = true,
    })
end
