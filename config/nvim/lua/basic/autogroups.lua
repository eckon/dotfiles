local yank_highlight = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = yank_highlight,
  pattern = '*',
})

local restore_cursor = vim.api.nvim_create_augroup('RestoreCursor', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    vim.cmd([[
      if &ft !~# 'commit\|rebase' && line("'\"") >= 1 && line("'\"") <= line("$") |
        execute "normal! g`\"" |
      endif
    ]])
  end,
  group = restore_cursor,
  pattern = '*',
})
