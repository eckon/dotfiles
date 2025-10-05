local autocmd = vim.api.nvim_create_autocmd
local augroup = require("eckon.helper.utils").augroup("autocmds")

autocmd("TextYankPost", {
  desc = "Highlight yanked area",
  callback = function()
    vim.highlight.on_yank({ timeout = 75 })
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

    ---@diagnostic disable-next-line: undefined-field
    local file = (vim.uv or vim.loop).fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  group = augroup,
})
