require('gitsigns').setup({ keymaps = {} })

local actions = require('diffview.actions')
require('diffview').setup({
  enhanced_diff_hl = true,
  keymaps = {
    file_history_panel = { ['q'] = '<CMD>tabclose<CR>' },
    file_panel = {
      ['q'] = '<CMD>tabclose<CR>',
      ['K'] = actions.scroll_view(-2),
      ['J'] = actions.scroll_view(2),
    },
    view = { ['q'] = '<CMD>tabclose<CR>' },
  },
})

vim.cmd([[
nnoremap <Leader>gg <CMD>DiffviewOpen<CR>

nnoremap <Leader>gs <CMD>Gitsigns stage_hunk<CR>
vnoremap <Leader>gs :Gitsigns stage_hunk<CR>
nnoremap <Leader>gu <CMD>Gitsigns undo_stage_hunk<CR>
vnoremap <Leader>gu :Gitsigns undo_stage_hunk<CR>

nnoremap <Leader>gb <CMD>lua require('gitsigns').blame_line({ full = true })<CR>

nnoremap ]c <CMD>Gitsigns next_hunk<CR>zz
nnoremap [c <CMD>Gitsigns prev_hunk<CR>zz
]])
