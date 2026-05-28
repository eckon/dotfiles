-- Handling of many actions via quickshell noctalia
local function ipc_cmd(action)
  return hl.dsp.exec_cmd("qs -c noctalia-shell ipc call " .. action)
end

-- Open applications/windows
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("ghostty"), { desc = "Open terminal" })
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"), { desc = "Open file manager" })
hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"), { desc = "Open browser" })
hl.bind("SUPER + SPACE", ipc_cmd("launcher toggle"), { desc = "Open menu" })
hl.bind(
  "SUPER + A",
  hl.dsp.exec_cmd("chromium --new-window --app=https://gemini.google.com/app"),
  { desc = "Open AI (Gemini)" }
)
hl.bind(
  "SUPER + SHIFT + A",
  hl.dsp.exec_cmd("chromium --new-window --app=https://chatgpt.com/"),
  { desc = "Open AI (ChatGPT)" }
)
hl.bind("SUPER + D", hl.dsp.exec_cmd("ghostty -e lazydocker"), { desc = "Open lazydocker" })
hl.bind("SUPER + SLASH", hl.dsp.exec_cmd("1password"), { desc = "Open password manager" })

-- Update open windows
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }), { desc = "Float window" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen(), { desc = "Fullscreen window" })
hl.bind("SUPER + P", hl.dsp.window.pin(), { desc = "Pin window" })
hl.bind("SUPER + X", hl.dsp.workspace.toggle_special(), { desc = "Toggle special workspace" })
hl.bind("SUPER + S", hl.dsp.layout("orientationcycle left top"), { desc = "Toggle position of master" })
hl.bind("SUPER + M", hl.dsp.layout("swapwithmaster master"), { desc = "Set current window master" })

-- Delete/Stop/Lock windows
hl.bind("SUPER + Q", hl.dsp.window.close(), { desc = "Close window" })
hl.bind("SUPER + ESCAPE", ipc_cmd("lockScreen lock"), { desc = "Lock screen" })
hl.bind("SUPER + SHIFT + ESCAPE", hl.dsp.exit(), { desc = "Exit hyprland" })

-- Move/Focus windows
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- Switch/Move workspaces
for i = 1, 9 do
  hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + SHIFT + X", hl.dsp.window.move({ workspace = "special" }))

-- Scroll through existing workspaces with SUPER + scroll or TAB
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with SUPER + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshot
hl.bind("PRINT", hl.dsp.exec_cmd("flameshot gui"), { desc = "Take screenshot" })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", ipc_cmd("volume increase"), { repeating = true })
hl.bind("XF86AudioLowerVolume", ipc_cmd("volume decrease"), { repeating = true })
hl.bind("XF86AudioMute", ipc_cmd("volume muteOutput"), { repeating = true })
hl.bind("XF86AudioMicMute", ipc_cmd("volume muteInput"), { repeating = true })
hl.bind("XF86MonBrightnessUp", ipc_cmd("brightness increase"), { repeating = true })
hl.bind("XF86MonBrightnessDown", ipc_cmd("brightness decrease"), { repeating = true })

hl.bind("XF86AudioNext", ipc_cmd("media next"), { locked = true })
hl.bind("XF86AudioPause", ipc_cmd("media playPause"), { locked = true })
hl.bind("XF86AudioPlay", ipc_cmd("media playPause"), { locked = true })
hl.bind("XF86AudioPrev", ipc_cmd("media previous"), { locked = true })
