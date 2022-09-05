require('neorg').setup({
  load = {
    ['core.defaults'] = {},
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
