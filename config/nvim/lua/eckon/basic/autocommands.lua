local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup('basic_autogroup', { clear = true })

autocmd('TextYankPost', {
  desc = 'Highlight yanked area',
  callback = function()
    vim.highlight.on_yank({ timeout = 75 })
  end,
  group = autogroup,
  pattern = '*',
})

autocmd('BufReadPost', {
  desc = 'Restore cursor to last visited position after reenter',
  callback = function()
    vim.cmd([[
      if &ft !~# 'commit\|rebase' && line("'\"") >= 1 && line("'\"") <= line("$") |
        execute "normal! g`\"" |
      endif
    ]])
  end,
  group = autogroup,
  pattern = '*',
})
