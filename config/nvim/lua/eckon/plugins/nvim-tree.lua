require('nvim-tree').setup({
  actions = { open_file = { quit_on_open = true } },
  git = { ignore = false },
  renderer = {
    add_trailing = true,
    group_empty = true,
  },
  view = {
    adaptive_size = true,
    hide_root_folder = true,
    relativenumber = true,
  },
})

local nnoremap = require('eckon.utils').nnoremap
nnoremap('<Leader>.', '<CMD>NvimTreeFindFileToggle<CR>')
