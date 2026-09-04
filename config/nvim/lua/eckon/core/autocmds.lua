local autocmd = vim.api.nvim_create_autocmd
local augroup = require("eckon.helper.utils").augroup("autocmds")

autocmd("TextYankPost", {
  desc = "Highlight yanked area",
  callback = function()
    vim.hl.hl_op()
  end,
  group = augroup,
})

autocmd("BufReadPost", {
  desc = "Restore cursor to last visited position after reenter",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local exclude = { "gitcommit" }
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  group = augroup,
})

autocmd("BufWritePre", {
  desc = "Create not existing nested directories on write",
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end

    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fs.mkdir(vim.fs.dirname(file), { parents = true })
  end,
  group = augroup,
})

autocmd("TextYankPost", {
  desc = "Yank-ring: store yanked text in registers 1-9",
  callback = function()
    if vim.v.event.operator == "y" then
      for i = 9, 1, -1 do -- Shift all numbered registers.
        vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
      end
    end
  end,
})
