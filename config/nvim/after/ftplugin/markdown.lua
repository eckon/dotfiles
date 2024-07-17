vim.opt_local.spell = true

vim.opt_local.colorcolumn = { "120" }
vim.opt_local.textwidth = 120

vim.opt_local.wrap = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

vim.b.miniindentscope_disable = true

vim.cmd("iabbrev <buffer> T - [ ]")
vim.cmd([[
  iabbrev <buffer> D <C-R>=system('date "+%Y-%m-%d" -d ""')[:-2]
  \<LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT>
]])

local bind_map = require("eckon.utils").bind_map

bind_map("v")("L", function()
  local positions = require("eckon.utils").get_visual_selection()
  local lines = vim.api.nvim_buf_get_lines(0, positions.visual_start.row - 1, positions.visual_end.row, false)

  -- lines allows multiple but links do not really help on multiple lines, so only allow one line
  if #lines > 1 then
    return
  end

  local content = lines[1]:sub(positions.visual_start.column, positions.visual_end.column)
  lines[1] = lines[1]:sub(1, positions.visual_start.column - 1)
    .. "["
    .. content
    .. "]("
    .. vim.fn.getreg("+")
    .. ")"
    .. lines[1]:sub(positions.visual_end.column + 1)

  vim.api.nvim_buf_set_lines(0, positions.visual_start.row - 1, positions.visual_end.row, false, lines)

  -- set cursor at the start of the link for quick edit via `ci(`
  -- 4 chars because `[`, `]`, `(` are added and one to move on the first link character
  vim.api.nvim_win_set_cursor(0, { positions.visual_start.row, positions.visual_end.column - 1 + 4 })
  require("eckon.utils").exit_visual_mode()
end, { desc = "Paste markdown link on visual selection", buffer = true, silent = true })

bind_map({ "n", "v" })("D", function()
  local restore_cursor = require("eckon.utils").save_cursor_position()

  local positions = require("eckon.utils").get_visual_selection()
  local range = positions.visual_start.row .. "," .. positions.visual_end.row

  -- from done to canceled (in that order to not override the previous)
  local toggle_checkbox = "s/- \\[x\\]/- [\\/]/ge"
  vim.api.nvim_command(":" .. range .. toggle_checkbox)

  -- from open/pending to done
  toggle_checkbox = "s/- \\[[ -]\\]/- [x]/ge"
  vim.api.nvim_command(":" .. range .. toggle_checkbox)

  vim.api.nvim_command("nohlsearch")

  restore_cursor()
end, { desc = "Toggle checkbox to finished state", buffer = true, silent = true })

bind_map({ "n", "v" })("S", function()
  local restore_cursor = require("eckon.utils").save_cursor_position()

  local positions = require("eckon.utils").get_visual_selection()
  local range = positions.visual_start.row .. "," .. positions.visual_end.row

  -- from open to pending (in that order to not override the previous)
  local toggle_checkbox = "s/- \\[ \\]/- [-]/ge"
  vim.api.nvim_command(":" .. range .. toggle_checkbox)

  -- from done/canceled to open
  toggle_checkbox = "s/- \\[[x\\/]\\]/- [ ]/ge"
  vim.api.nvim_command(":" .. range .. toggle_checkbox)

  vim.api.nvim_command("nohlsearch")

  restore_cursor()
end, { desc = "Toggle checkbox to open state", buffer = true, silent = true })
