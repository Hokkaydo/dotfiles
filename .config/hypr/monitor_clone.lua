-- Monitor configuration: clone/mirror mode
-- eDP-1 is the source, HDMI-A-1 mirrors it
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080",
    position = "0x280",
    scale    = 1,
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080",
    position = "0x0",
    scale    = 1,
    mirror   = "eDP-1",
})
