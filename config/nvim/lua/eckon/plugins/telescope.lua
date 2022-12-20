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
  nnoremap('<Leader>fA', require('telescope.builtin').live_grep)
  nnoremap('<Leader>fr', require('telescope.builtin').resume)

  nnoremap('<Leader>fb', function() require('telescope.builtin').buffers({ sort_mru = true }) end)
  nnoremap('<Leader>ff', require('telescope.builtin').find_files)
  nnoremap('<Leader>fg', require('telescope.builtin').git_status)
  nnoremap('<Leader>fl', require('telescope.builtin').current_buffer_fuzzy_find)
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
  nnoremap('<Leader>fh', require('telescope.builtin').help_tags)
end

return M
