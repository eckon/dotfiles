vim.opt_local.spell = true

vim.opt_local.colorcolumn = { "120" }
vim.opt_local.textwidth = 120

vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = ""

vim.opt_local.wrap = true
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

vim.b.miniindentscope_disable = true

local autocmd = vim.api.nvim_create_autocmd
local augroup = require("eckon.helper.utils").augroup("markdown", { clear = false })

autocmd("ModeChanged", {
  buffer = 0, -- make it only local when its being attached (so only markdown files)
  callback = function()
    local mode = vim.api.nvim_get_mode().mode

    if mode == "n" then
      -- Normal mode → conceal ON
      vim.opt_local.conceallevel = 2
    else
      -- Any other mode → conceal OFF
      vim.opt_local.conceallevel = 0
    end
  end,
  desc = "Toggle conceal level based on the current mode for easier reading",
  group = augroup,
})

local bind_map = require("eckon.helper.utils").bind_map

-- Might want to look into: https://github.com/bngarren/checkmate.nvim for things to copy
bind_map("v")("L", function()
  local positions = require("eckon.helper.utils").get_visual_selection()

  -- selections allow multiple lines but links do not really help there, so only allow one line
  if #positions.text > 1 then
    return
  end

  local link = "[" .. positions.text[1] .. "](" .. vim.fn.getreg("+") .. ")"

  vim.api.nvim_buf_set_text(
    0,
    positions.visual_start.row - 1,
    positions.visual_start.column - 1,
    positions.visual_end.row - 1,
    positions.visual_end.column,
    { link }
  )

  -- keep cursor on the first selection
  vim.api.nvim_win_set_cursor(0, { positions.visual_start.row, positions.visual_start.column })

  -- get out of visual mode
  vim.cmd.normal({ vim.api.nvim_get_mode().mode, bang = true })
end, { desc = "Paste markdown link on visual selection", buffer = true, silent = true })
