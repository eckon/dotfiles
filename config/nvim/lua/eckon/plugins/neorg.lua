local M = {
  'nvim-neorg/neorg',
  ft = 'norg',
  cmd = 'Neorg',
  build = ':Neorg sync-parsers',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('neorg').setup({
      load = {
        ['core.defaults'] = {},
        ['core.norg.news'] = { config = { check_news = false } },
        ['core.norg.concealer'] = {},
        ['core.norg.dirman'] = {
          config = {
            workspaces = {
              private = '~/Documents/notes/private',
              work = '~/Documents/notes/work',
            },
            autochdir = true,
            index = '_todo.norg',
          },
        },
      },
    })
  end,
}

return M
