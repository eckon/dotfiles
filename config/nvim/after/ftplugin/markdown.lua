vim.opt_local.spell = true

vim.opt_local.colorcolumn = {}
vim.opt_local.textwidth = 120

vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

local utils = require("eckon.helper.utils")

utils.bind_map("v")("L", function()
  local selection = utils.get_visual_selection()
  local range = selection.range

  -- selections allow multiple lines but links do not really help there, so only allow one line
  if #selection.text > 1 then
    return vim.notify("Markdown link needs a single line selection", vim.log.levels.WARN)
  end

  local text, url = selection.text[1], vim.trim(vim.fn.getreg("+"))
  if text == "" or url == "" then
    return vim.notify("Markdown link needs a selection and a clipboard value", vim.log.levels.WARN)
  end

  -- allow the inverse workflow: url in the buffer, label in the clipboard
  if text:find("^%w+://") then
    text, url = url, text
  end

  local link = ("[%s](%s)"):format(text, url)
  vim.api.nvim_buf_set_text(range.buf, range.start_row, range.start_col, range.end_row, range.end_col, { link })

  -- keep cursor on the start of the new link and leave visual mode
  vim.api.nvim_win_set_cursor(0, vim.pos(range.buf, range.start_row, range.start_col):to_cursor())
  vim.cmd.normal({ vim.keycode("<Esc>"), bang = true })
end, { desc = "Paste markdown link on visual selection", buf = 0, silent = true })
