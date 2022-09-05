local actions = require('telescope.actions')
require('telescope').setup({
  defaults = {
    color_devicons = true,
    layout_strategy = 'vertical',
    path_display = { 'truncate' },
    mappings = {
      i = {
        ['<C-j>'] = actions.cycle_history_next,
        ['<C-k>'] = actions.cycle_history_prev,
        ['<C-f>'] = actions.to_fuzzy_refine,
      },
    },
  },
})

require('telescope').load_extension('fzf')

local nnoremap = require('eckon.utils').nnoremap

nnoremap('<Leader>fa', function()
  require('telescope.builtin').grep_string({ search = vim.fn.input({ prompt = 'Grep > ' }) })
end)
nnoremap('<Leader>fA', require('telescope.builtin').live_grep)
nnoremap('<Leader>fr', require('telescope.builtin').resume)

nnoremap('<Leader>fb', function()
  require('telescope.builtin').buffers({ sort_mru = true })
end)
nnoremap('<Leader>ff', require('telescope.builtin').find_files)
nnoremap('<Leader>fg', require('telescope.builtin').git_status)
nnoremap('<Leader>fl', require('telescope.builtin').current_buffer_fuzzy_find)
nnoremap('<Leader>fs', require('telescope.builtin').spell_suggest)
nnoremap('<Leader>fh', require('telescope.builtin').help_tags)
