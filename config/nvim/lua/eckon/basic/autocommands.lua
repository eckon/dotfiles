local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup("basic_autogroup_eckon", {})

autocmd("TextYankPost", {
  desc = "Highlight yanked area",
  callback = function() vim.highlight.on_yank({ timeout = 75 }) end,
  group = autogroup,
})

autocmd("BufReadPost", {
  desc = "Restore cursor to last visited position after reenter",
  callback = function(args)
    -- ignore temporary git files (commit message, rebase window)
    if vim.regex("/\\.git/"):match_str(args.file) then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  group = autogroup,
})
