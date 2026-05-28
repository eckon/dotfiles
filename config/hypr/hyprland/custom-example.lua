-- Information
-- - https://wiki.hypr.land/Configuring/Basics/Monitors/
-- - https://wiki.hypr.land/Configuring/Basics/Window-Rules/

local main_monitor = "DP-3"
local right_monitor = "DP-2"

hl.monitor({
  output = main_monitor,
  mode = "2560x1440@144",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = right_monitor,
  mode = "1920x1080@144",
  position = "2560x0",
  scale = 1,
})

hl.workspace_rule({ workspace = "1", monitor = main_monitor })
hl.workspace_rule({ workspace = "2", monitor = main_monitor })
hl.workspace_rule({ workspace = "3", monitor = main_monitor })
hl.workspace_rule({ workspace = "4", monitor = main_monitor })
hl.workspace_rule({ workspace = "5", monitor = main_monitor })
hl.workspace_rule({ workspace = "6", monitor = main_monitor })
hl.workspace_rule({ workspace = "7", monitor = right_monitor })
hl.workspace_rule({ workspace = "8", monitor = right_monitor })
hl.workspace_rule({ workspace = "9", monitor = right_monitor })

-- # additional settings that are specific to the computer
hl.config({
  input = {
    kb_layout = "us",
    sensitivity = -0.3,
  },
})

hl.on("hyprland.start", function()
  hl.exec_cmd("discord")
  hl.exec_cmd("Telegram")

  hl.exec_cmd("ghostty", { workspace = 1 })
  hl.exec_cmd("firefox", { workspace = 2 })
end)
