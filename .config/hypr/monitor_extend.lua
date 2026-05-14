-- Monitor configuration: extend mode
-- HDMI-A-1 on the left, eDP-1 on the right
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080",
    position = "1920x0",
    scale    = 1,
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080", --3840x2160
    position = "0x0",
    scale    = 1,
})
