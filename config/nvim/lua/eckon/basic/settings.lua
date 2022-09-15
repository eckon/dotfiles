local set = vim.opt

vim.g.mapleader = ' '

set.shell = 'bash'
set.undofile = true
set.swapfile = false
set.title = true

set.completeopt = { 'menuone', 'noinsert', 'noselect' }

set.magic = true
set.lazyredraw = true
set.ignorecase = true
set.smartcase = true

set.number = true
set.relativenumber = true

set.shiftwidth = 2
set.tabstop = 2
set.softtabstop = 2
set.smartindent = true
set.expandtab = true

set.shortmess:append('c')
set.showmode = false

set.signcolumn = 'yes'

set.splitbelow = true
set.splitright = true

set.updatetime = 100

set.wildmode = { 'list:longest', 'list:full' }

set.cursorline = true
set.colorcolumn = { '80', '120', '121' }

set.list = true
set.listchars = { nbsp = '¬', extends = '»', precedes = '«', lead = ' ', trail = '·', space = ' ', tab = '▸ ' }

set.scrolloff = 5
set.sidescrolloff = 5
set.wrap = false

set.termguicolors = true

set.winbar = '%t %m'

set.foldenable = false

-- TODO: set spell always true because of spelloption -> noplainbuffer
--       but for now it seems to be not working (should show spell errors in comments)
--       (note, syntax does not need to be true, as treesitter handles it)
