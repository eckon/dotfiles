require('gitsigns').setup({ keymaps = {} })

local nnoremap = require('eckon.utils').nnoremap

nnoremap('<Leader>gg', '<CMD>tab G<CR>')
nnoremap('<Leader>gd', '<CMD>Gdiffsplit!<CR>')
nnoremap('<Leader>gh', '<CMD>0GcLog<CR>')

nnoremap('<Leader>gb', function() require('gitsigns').blame_line({ full = true }) end)

nnoremap(']c', '<CMD>Gitsigns next_hunk<CR>zz')
nnoremap('[c', '<CMD>Gitsigns prev_hunk<CR>zz')
