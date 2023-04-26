local noremap = require("eckon.utils").noremap
local nnoremap = require("eckon.utils").nnoremap
local vnoremap = require("eckon.utils").vnoremap
local inoremap = require("eckon.utils").inoremap

--- OVERWRITE mappings (mainly enhances default behaviour)
-- disable annoying keys
nnoremap("<F1>", "<Nop>")
inoremap("<F1>", "<Nop>")
nnoremap("U", "<Nop>")
noremap("<Space>", "<Nop>")

-- re-highlight text after indenting
vnoremap("<", "<gv")
vnoremap(">", ">gv")

-- keep cursor position while joining single lines
nnoremap("J", function()
  local prev_pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_command("normal! " .. vim.v.count + 1 .. "J")
  vim.api.nvim_win_set_cursor(0, prev_pos)
end, { desc = "Join lines without moving cursor" })

-- center view after common jump actions
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-d>", "<C-d>zz")

--- NEW mappings
nnoremap("[q", "<CMD>cprevious<CR>zz", { desc = "Jump to previous quickfix item" })
nnoremap("]q", "<CMD>cnext<CR>zz", { desc = "Jump to next quickfix item" })
nnoremap("[Q", "<CMD>cfirst<CR>zz", { desc = "Jump to first quickfix item" })
nnoremap("]Q", "<CMD>clast<CR>zz", { desc = "Jump to last quickfix item" })

vnoremap("<Leader>p", '"_dP', { desc = "Paste without overwriting register" })
vnoremap("<Leader>y", '"+y', { desc = "Copy into system clipboard" })
vnoremap("<Leader>d", '"_d', { desc = "Delete without overwriteing register" })

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

nnoremap("k", jumplisted_relative_movement("k"), { expr = true, desc = "Jump to previous line and append to jumplist" })
nnoremap("j", jumplisted_relative_movement("j"), { expr = true, desc = "Jump to next line and append to jumplist" })
