-- █▀▀ █▄░█ █░█
-- ██▄ █░▀█ ▀▄▀

hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")    -- Fix java wm bug
hl.env("XDG_CONFIG_HOME", "/home/hokkaydo/.config")
hl.env("ANKI_WAYLAND", "1")                     -- Set anki to wayland mode
hl.env("MOZ_ENABLE_WAYLAND", "1")               -- Enable wayland on firefox
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")          -- Set qt theme
hl.env("QT_LOGGING_RULES", "qt.qpa.*=false")     -- Suppress QT warnings (useful for plt)
hl.env("SSH_AUTH_SOCK", "$XDG_RUNTIME_DIR/gcr/ssh") -- GCR ssh keyring
hl.env("XCURSOR_THEME", "Simp1e")                -- Set cursor theme
hl.env("QT_QPA_PLATFORM", "wayland;xcb")         -- Set qt platform
hl.env("GDK_BACKEND", "wayland,x11")             -- Set gdk backend
hl.env("SDL_VIDEODRIVER", "wayland")              -- Set sdl videodriver
hl.env("CLUTTER_BACKEND", "wayland")              -- Set clutter backend
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")         -- Set current desktop
hl.env("XDG_SESSION_TYPE", "wayland")              -- Set session type
hl.env("XDG_SESSION_DESKTOP", "Hyprland")          -- Set session desktop
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")         -- Enable auto screen scale factor for qt
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1") -- Disable window decoration for qt on wayland
hl.env("LIBVA_DRIVER_NAME", "nvidia")              -- Set libva driver for nvidia
hl.env("MOZ_DISABLE_RDD_SANDBOX", "1")             -- Allow vaapi outside firefox rdd
hl.env("NVD_BACKEND", "direct")                    -- Set libva-nvidia direct backend
hl.env("WLR_NO_HARDWARE_CURSORS", "1")             -- Software cursors (nvidia bug)
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")      -- Set glx vendor library for nvidia
--hl.env("GTK_THEME", "Tokyonight-Dark-B")
hl.env("eDP_1_WALLPAPER_STORE_PATH", "/home/hokkaydo/.cache/eDP_1_current_wallpaper")
hl.env("HDMI_A_1_WALLPAPER_STORE_PATH", "/home/hokkaydo/.cache/HDMI_A_1_current_wallpaper")
hl.env("XCURSOR_SIZE", "24")

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
require("monitor")


-------------------------------
---- AUTOSTART ----
-------------------------------

-- exec (runs on every reload)
hl.on("config.reloaded", function()
    hl.exec_cmd("sh ~/.local/scripts/relaunch.sh")
end)

-- exec-once (runs only at launch)
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("~/.config/hypr/scripts/sleep.sh")
    --hl.exec_cmd("~/.local/scripts/theming.sh")
    hl.exec_cmd("hyprpm enable hyprexpo")
    --hl.exec_cmd("sleep 1 && firefox --new-window /home/hokkaydo/Documents/Firefox/startup.html")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --watch cliphist store")
    -- Allow gparted to open graphic interface
    hl.exec_cmd("xhost +SI:localuser:root")
    hl.exec_cmd("sh ~/.local/scripts/relaunch.sh")
end)


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    input = {
        kb_layout  = "be",
        kb_variant = "",
        kb_model   = "",
        kb_options = "compose:rctrl",
        kb_rules   = "",

        follow_mouse = 0,

        touchpad = {
            natural_scroll = true,
        },

        numlock_by_default = true,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification
    },
})

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 20,
        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(ff9d00ee)", "rgba(e500d6ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",
    },
})

hl.config({
    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        mouse_move_focuses_monitor = true,
        focus_on_activate        = true,
        mouse_move_enables_dpms  = true,
    },
})

hl.config({
    decoration = {
        rounding = 10,

        blur = {
            enabled = true,
            size    = 5,
            passes  = 5,
        },

        shadow = {
            color        = "rgba(1a1a1aee)",
            render_power = 3,
            range        = 4,
            enabled      = true,
        },
    },
})

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",      enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",   enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",       enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle",  enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",         enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",   enabled = true, speed = 6,  bezier = "default" })

hl.config({
    dwindle = {
        preserve_split = true,
        smart_split = 0,
        split_width_multiplier = 1.5,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

-- Example per-device config
-- hl.device({
--     name        = "epic-mouse-v1",
--     sensitivity = -0.5,
-- })

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})


--------------------------------
---- WINDOW RULES ----
--------------------------------

hl.window_rule({ match = { title = "confirm" },         float = true })
hl.window_rule({ match = { title = "dialog" },          float = true })
hl.window_rule({ match = { title = "download" },        float = true })
hl.window_rule({ match = { title = "error" },           float = true })
hl.window_rule({ match = { title = "splash" },          float = true })
hl.window_rule({ match = { title = "confirmreset" },    float = true })
hl.window_rule({ match = { title = "Open File" },       float = true })
hl.window_rule({ match = { title = "branchdialog" },    float = true })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, float = true })

hl.window_rule({ match = { class = "jetbrains-idea" },  center = true })

hl.window_rule({ match = { class = "^(firefox)$" },  opacity = "0.9 0.9" })
hl.window_rule({ match = { class = "^(obsidian)$" }, opacity = "0.7 0.7" })
hl.window_rule({ match = { class = "^(discord)$" },  opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(ParaView)$" }, monitor = "HDMI-A-1" })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- █▀ █▀▀ █▀█ █▀▀ █▀▀ █▄░█ █▀ █░█ █▀█ ▀█▀
-- ▄█ █▄▄ █▀▄ ██▄ ██▄ █░▀█ ▄█ █▀█ █▄█ ░█░
hl.bind("Print",               hl.dsp.exec_cmd("~/.local/scripts/screenshot.sh --monitor1"))
hl.bind("CTRL + Print",        hl.dsp.exec_cmd("~/.local/scripts/screenshot.sh --monitor2"))
hl.bind("SHIFT + Print",       hl.dsp.exec_cmd("~/.local/scripts/screenshot.sh --selection"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("~/.local/scripts/screenshot.sh --active"))

-- APPLICATIONS
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("discord"))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("sh ~/.config/rofi/bin/powermenu"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.layout("swapsplit"))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("spotify-launcher"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("kitty yazi"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("rofi -show emoji"))

-- TMP Shortcuts
hl.bind(mainMod .. " + CTRL + M", hl.dsp.exec_cmd("code ~/dev/epl/TFE26-087/"))

-- SCRIPTS
hl.bind(mainMod .. " + T",         hl.dsp.exec_cmd("sh ~/.local/scripts/remote-control.sh 2539"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("[fullscreen] kitty ~/.local/scripts/git_push.sh"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("sh ~/.config/hypr/scripts/toggle_projection.sh"))
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd("sh ~/.local/scripts/wallpaper.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("sh ~/.local/scripts/change_wp.sh"))

hl.bind(mainMod .. " + L",         hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

-- █░█ █▀█ █░░ █░█ █▀▄▀█ █▀▀
-- ▀▄▀ █▄█ █▄▄ █▄█ █░▀░█ ██▄
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.local/scripts/volume.sh up"),   { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.local/scripts/volume.sh down"), { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("~/.local/scripts/volume.sh mute"), { repeating = true })

-- Resume-pause spotify
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("playerctl --player=spotify play-pause"))
hl.bind(mainMod .. " + ALT + S",   hl.dsp.exec_cmd("playerctl --player=spotify next"))

-- Backlight
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.local/scripts/backlight.sh down 5"), { repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/.local/scripts/backlight.sh up 5"),   { repeating = true })

-- Resize submap
hl.bind("ALT + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("right",  hl.dsp.window.resize({ x = 10, y = 0 }),  { repeating = true })
    hl.bind("left",   hl.dsp.window.resize({ x = -10, y = 0 }), { repeating = true })
    hl.bind("up",     hl.dsp.window.resize({ x = 0, y = -10 }), { repeating = true })
    hl.bind("down",   hl.dsp.window.resize({ x = 0, y = 10 }),  { repeating = true })
    hl.bind("Escape", hl.dsp.submap("reset"))
end)


-- █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀▄▀█ ▄▀█ █▄░█ ▄▀█ █▀▀ █▀▄▀█ █▀▀ █▄░█ ▀█▀
-- ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █░▀░█ █▀█ █░▀█ █▀█ █▄█ █░▀░█ ██▄ █░▀█ ░█░

hl.bind(mainMod .. " + Space",         hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + Tab",           hl.dsp.window.float({ action = "toggle" }))


-- █▀▀ █▀█ █▀▀ █░█ █▀
-- █▀░ █▄█ █▄▄ █▄█ ▄█

-- Move focus with ALT + arrow keys
hl.bind("ALT + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("ALT + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("ALT + right", hl.dsp.focus({ direction = "right" }))
hl.bind("ALT + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + numpad keys
hl.bind(mainMod .. " + KP_End",    hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + KP_Down",   hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + KP_Next",   hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + KP_Left",   hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + KP_Begin",  hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + KP_Right",  hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + KP_Home",   hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + KP_Up",     hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + KP_Prior",  hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + KP_Insert", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + left",  hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind(mainMod .. " + right", hl.dsp.focus({ workspace = "+1" }), { repeating = true })

-- Move active window to a workspace with mainMod + SHIFT + numpad keys
hl.bind(mainMod .. " + SHIFT + KP_End",    hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + KP_Down",   hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + KP_Next",   hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + KP_Left",   hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + KP_Begin",  hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + KP_Right",  hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + KP_Home",   hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + KP_Up",     hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + KP_Prior",  hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + KP_Insert", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ workspace = "-1" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with ALT + LMB/RMB and dragging
hl.bind("ALT + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })
