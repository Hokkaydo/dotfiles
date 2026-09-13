-- Single source of truth for monitor layout.
-- Mode is persisted by hypr/scripts/toggle_projection.sh, which writes
-- "extend", "clone room", or "clone tv" to the state file and reloads Hyprland.

local state_home = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
local statefile = state_home .. "/hypr/monitor_mode"

local function read_mode()
    local f = io.open(statefile, "r")
    if not f then return "extend" end
    local mode = f:read("l")
    f:close()
    if mode == "clone room" or mode == "clone tv" then return mode end
    return "extend"
end

local mode = read_mode()

if mode == "clone room" or mode == "clone tv" then
    local hdmi_mode = (mode == "clone tv") and "1366x768" or "1920x1080" -- TV Salon / Dual Screen Room

    -- eDP-1 is the source, HDMI-A-1 mirrors it
    hl.monitor({
        output   = "eDP-1",
        mode     = "1920x1080",
        position = "0x280",
        scale    = 1,
    })

    hl.monitor({
        output   = "HDMI-A-1",
        mode     = hdmi_mode,
        position = "0x0",
        scale    = 1,
        mirror   = "eDP-1",
    })
else
    -- extend: HDMI-A-1 on the left, eDP-1 on the right
    hl.monitor({
        output   = "eDP-1",
        mode     = "1920x1080",
        position = "1920x0",
        scale    = 1,
    })

    hl.monitor({
        output   = "HDMI-A-1",
        mode     = "1920x1080", -- Dual Screen Room
        position = "0x0",
        scale    = 1,
    })
end
