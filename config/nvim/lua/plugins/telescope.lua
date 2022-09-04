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

vim.cmd([[
nnoremap <Leader>fa <CMD>lua require('telescope.builtin').grep_string({ search = vim.fn.input({ prompt = 'Grep > ' }) })<CR>
nnoremap <Leader>fA <CMD>lua require('telescope.builtin').live_grep()<CR>
nnoremap <Leader>fr <CMD>lua require('telescope.builtin').resume()<CR>

nnoremap <Leader>fb <CMD>lua require('telescope.builtin').buffers({ sort_mru = true })<CR>
nnoremap <Leader>ff <CMD>lua require('telescope.builtin').find_files()<CR>
nnoremap <Leader>fg <CMD>lua require('telescope.builtin').git_status()<CR>
nnoremap <Leader>fl <CMD>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>
nnoremap <Leader>fs <CMD>lua require('telescope.builtin').spell_suggest()<CR>
]])
