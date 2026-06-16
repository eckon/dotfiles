hl.on("hyprland.start", function()
  -- start bar and many other configuration options (app launcher, lock screen, etc.)
  hl.exec_cmd("qs -c noctalia-shell")

  -- allow for permission asking of gui applications
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- NOTE: create a `custom.lua` in hypr/hyprland to setup computer specific settings that should not be versioned
-- this could include settings like monitor, workspace, etc.
-- for examples see `./hyprland/custom-example.lua`
require("hyprland.custom")
require("hyprland.keybinding")

hl.config({
  general = {
    border_size = 2,
    gaps_in = 5,
    gaps_out = 10,
    layout = "master",
    allow_tearing = false,

    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

    resize_on_border = true,
  },
})

hl.config({
  decoration = {
    rounding = 5,
    rounding_power = 2,
  },
})

hl.config({
  input = {
    follow_mouse = true,
    kb_layout = "us",
    -- allow using "umlaute" by pressing `right-alt` before `"` etc.,
    kb_variant = "altgr-intl",
  },
})

hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "default" })

-- put flameshot window selection over the screen instead of as a new window
-- see: https://flameshot.org/docs/guide/wayland-help/#multi-display-issue
hl.window_rule({
  name = "flameshot-multi-display-fix",
  match = { class = "flameshot" },
  float = true,
})

---------------------------------------------------------------------------------------------------------------------
-- following parts are taking from default config: https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua
---------------------------------------------------------------------------------------------------------------------
hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
})

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})

hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move = "20 monitor_h-120",
  float = true,
})
