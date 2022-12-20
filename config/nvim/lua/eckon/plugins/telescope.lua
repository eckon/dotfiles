local nnoremap = require('eckon.utils').nnoremap

local M = {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'kyazdani42/nvim-web-devicons' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
}

M.config = function()
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
end

M.init = function()
  nnoremap(
    '<Leader>fa',
    function() require('telescope.builtin').grep_string({ search = vim.fn.input({ prompt = 'Grep > ' }) }) end
  )
  nnoremap('<Leader>fA', function() require('telescope.builtin').live_grep() end)
  nnoremap('<Leader>fr', function() require('telescope.builtin').resume() end)

  nnoremap('<Leader>fb', function() require('telescope.builtin').buffers({ sort_mru = true }) end)
  nnoremap('<Leader>ff', function() require('telescope.builtin').find_files() end)
  nnoremap('<Leader>fg', function() require('telescope.builtin').git_status() end)
  nnoremap('<Leader>fl', function() require('telescope.builtin').current_buffer_fuzzy_find() end)
  nnoremap(
    '<Leader>fs',
    function()
      require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor({
        prompt_title = '',
        layout_config = {
          height = 0.25,
          width = 0.25,
        },
      }))
    end
  )
  nnoremap('<Leader>fh', function() require('telescope.builtin').help_tags() end)
end

return M
