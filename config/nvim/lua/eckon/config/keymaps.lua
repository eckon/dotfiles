local bind_map = require("eckon.utils").bind_map
local nmap = bind_map("n")
local vmap = bind_map("v")

--- OVERWRITE mappings (mainly enhances default behaviour)
-- disable annoying keys
bind_map({ "i", "n" })("<F1>", "<Nop>")
bind_map({ "v", "n", "o" })("<Space>", "<Nop>")

-- undo `u` redo `U` -- `U` normal function is useless (I would otherwise <Nop> it)
nmap("U", "<C-r>")

-- re-highlight text after indenting
vmap("<", "<gv")
vmap(">", ">gv")

-- keep cursor position while joining single lines
nmap("J", function()
  local prev_pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_command("normal! " .. vim.v.count + 1 .. "J")
  vim.api.nvim_win_set_cursor(0, prev_pos)
end, { desc = "Join lines without moving cursor" })

-- center view after common jump actions
nmap("<C-u>", "<C-u>zz")
nmap("<C-d>", "<C-d>zz")

--- NEW mappings
nmap("[q", "<CMD>cprevious<CR>zz", { desc = "Jump to previous quickfix item" })
nmap("]q", "<CMD>cnext<CR>zz", { desc = "Jump to next quickfix item" })
nmap("[Q", "<CMD>cfirst<CR>zz", { desc = "Jump to first quickfix item" })
nmap("]Q", "<CMD>clast<CR>zz", { desc = "Jump to last quickfix item" })
nmap("<Leader>C", "<CMD>CustomCommand<CR>", { desc = "Call CustomCommand" })

vmap("<Leader>p", '"_dP', { desc = "Paste without overwriting register" })
vmap("<Leader>y", '"+y', { desc = "Copy into system clipboard" })
vmap("<Leader>d", '"_d', { desc = "Delete without overwriteing register" })

---Add relative line movement also to the jumplist
---@param key string
local jumplisted_relative_movement = function(key)
  return function()
    if vim.v.count > 1 then
      return "m'" .. vim.v.count .. key
    end
    return key
  end
end

nmap("k", jumplisted_relative_movement("k"), { expr = true, desc = "Jump to previous line and append to jumplist" })
nmap("j", jumplisted_relative_movement("j"), { expr = true, desc = "Jump to next line and append to jumplist" })
