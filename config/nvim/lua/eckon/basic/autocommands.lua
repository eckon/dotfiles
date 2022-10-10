local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup('basic_autogroup', { clear = true })

autocmd('TextYankPost', {
  desc = 'Highlight yanked area',
  callback = function() vim.highlight.on_yank({ timeout = 75 }) end,
  group = autogroup,
  pattern = '*',
})

autocmd('BufReadPost', {
  desc = 'Restore cursor to last visited position after reenter',
  callback = function()
    -- for some reason filetype is not correctly set at this point, so can not check if commit or not (ignore for now)
    local last_cursor_position = vim.fn.line('\'"')
    local last_line = vim.fn.line('$')

    if last_cursor_position >= 1 and last_cursor_position <= last_line then
      vim.api.nvim_command('normal! g`"')
    end
  end,
  group = autogroup,
  pattern = '*',
})
