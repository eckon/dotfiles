require('gitsigns').setup({ keymaps = {} })

local nnoremap = require('eckon.utils').nnoremap

nnoremap('<Leader>gb', function() require('gitsigns').blame_line({ full = true }) end)

nnoremap(']c', '<CMD>Gitsigns next_hunk<CR>zz')
nnoremap('[c', '<CMD>Gitsigns prev_hunk<CR>zz')
