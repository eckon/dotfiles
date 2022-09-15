local noremap = require('eckon.utils').noremap
local nnoremap = require('eckon.utils').nnoremap
local vnoremap = require('eckon.utils').vnoremap
local inoremap = require('eckon.utils').inoremap

-- disable annoying keys
nnoremap('<F1>', '<Nop>')
inoremap('<F1>', '<Nop>')
nnoremap('U', '<Nop>')
noremap('<Space>', '<Nop>')

-- rehighlight text after indenting
vnoremap('<', '<gv')
vnoremap('>', '>gv')

--- center view after common jump actions
nnoremap('<C-u>', '<C-u>zz')
nnoremap('<C-d>', '<C-d>zz')

-- append jump-commands for quickfix-list jumps
nnoremap('[q', '<CMD>cprevious<CR>zz')
nnoremap(']q', '<CMD>cnext<CR>zz')
nnoremap('[Q', '<CMD>cfirst<CR>zz')
nnoremap(']Q', '<CMD>clast<CR>zz')

-- mappings to handle copy/paste/delete to different registers
vnoremap('<Leader>p', '"_dP')
vnoremap('<Leader>y', '"+y')
vnoremap('<Leader>d', '"_d')
