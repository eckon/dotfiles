local bind_map = require("eckon.utils").bind_map
local is_wsl = vim.fn.has("wsl") == 1

-- mainly a file to overwrite general things
-- as depending on the OS things work differently

-- overwrites normal <Leader>y to use clipboard in wsl (pipe selection into command)
if is_wsl then
  bind_map("v")(
    "<Leader>y",
    'y<CMD>system("/mnt/c/windows/system32/clip.exe", @")<CR>',
    { desc = "Copy into windows system clipboard (from wsl)" }
  )
end
