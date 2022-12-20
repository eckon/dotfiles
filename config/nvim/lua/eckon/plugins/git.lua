local nnoremap = require('eckon.utils').nnoremap

local M = {
  {
    'tpope/vim-fugitive',
    event = 'BufReadPre',
    cmd = 'G',
    init = function()
      nnoremap('<Leader>gg', '<CMD>tab G<CR>')
      nnoremap('<Leader>gd', '<CMD>Gdiffsplit!<CR>')
      nnoremap('<Leader>gh', '<CMD>0GcLog<CR>')
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    config = function() require('gitsigns').setup({ keymaps = {} }) end,
    init = function()
      nnoremap('<Leader>gb', function() require('gitsigns').blame_line({ full = true }) end)
      nnoremap(']c', '<CMD>Gitsigns next_hunk<CR>zz')
      nnoremap('[c', '<CMD>Gitsigns prev_hunk<CR>zz')
    end,
  },
}

return M
