require('eckon.plugins.packer')

require('impatient')

require('eckon.plugins.dap')
require('eckon.plugins.git')
require('eckon.plugins.lsp')
require('eckon.plugins.lualine')
require('eckon.plugins.neorg')
require('eckon.plugins.nvim-tree')
require('eckon.plugins.telescope')
require('eckon.plugins.treesitter')

-- small requires (dont want to have too many files)
local noremap = require('eckon.utils').noremap

require('Comment').setup()
require('nvim-surround').setup()
require('hop').setup()
noremap('H', '<CMD>HopChar1<CR>')

local onedark = require('onedark')
onedark.setup({ style = 'warmer' })
onedark.load()
