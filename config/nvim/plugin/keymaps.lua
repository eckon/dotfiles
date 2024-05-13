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
  local restore_cursor = require("eckon.utils").save_cursor_position()
  vim.api.nvim_command("normal! " .. vim.v.count + 1 .. "J")
  restore_cursor()
end, { desc = "Join lines without moving cursor" })

-- center view after common jump actions
nmap("<C-u>", "<C-u>zz")
nmap("<C-d>", "<C-d>zz")

--- NEW mappings
nmap("[q", "<CMD>cprevious<CR>zz", { desc = "Jump to previous quickfix item" })
nmap("]q", "<CMD>cnext<CR>zz", { desc = "Jump to next quickfix item" })
nmap("[Q", "<CMD>cfirst<CR>zz", { desc = "Jump to first quickfix item" })
nmap("]Q", "<CMD>clast<CR>zz", { desc = "Jump to last quickfix item" })

-- align deleting to pasting, as `v_P` is the same as  `"_dp` so should be `D` as well
vmap("D", '"_d', { desc = "Delete without overwriting register" })
vmap("<Leader>y", '"+y', { desc = "Copy into system clipboard" })

---Enhance jk by
---1. adding it to the jumplist if its a jump higher than 1
---2. handle softwrap if its only by line
---@param key string
local enhance_jk = function(key)
  return function()
    if vim.v.count > 1 then
      return "m'" .. vim.v.count .. key
    end

    return "g" .. key
  end
end

nmap("k", enhance_jk("k"), { expr = true, desc = "Jump to previous line and append to jumplist (handle softwrap)" })
nmap("j", enhance_jk("j"), { expr = true, desc = "Jump to next line and append to jumplist (handle softwrap)" })
