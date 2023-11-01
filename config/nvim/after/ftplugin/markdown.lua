vim.opt_local.spell = true

vim.opt_local.conceallevel = 2
vim.opt_local.colorcolumn = { "120" }
vim.opt_local.textwidth = 120

vim.opt_local.wrap = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

-- todo highlight is ugly so ill overwrite it for now (probably should be done differently)
vim.api.nvim_set_hl(0, "@text.todo", { link = "Question" })

vim.cmd("iabbrev <buffer> T - [ ]")
vim.cmd([[
  iabbrev <buffer> D <C-R>=system('date "+%Y-%m-%d" -d ""')[:-2]
  \<LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT>
]])

require("eckon.utils").bind_map({ "n", "v" })("s", function()
  local positions = require("eckon.utils").get_visual_selection()
  local range = positions.visual_start.row .. "," .. positions.visual_end.row
  local toggle_checkbox = "s/\\v(\\[[ xX/]])/\\=submatch(1) == '[ ]' ? '[x]' : '[ ]'/ge"

  local restore_cursor = require("eckon.utils").save_cursor_position()

  vim.api.nvim_command(":" .. range .. toggle_checkbox)
  vim.api.nvim_command("nohlsearch")

  restore_cursor()
end, { desc = "Toggle checkbox", buffer = true, silent = true })
