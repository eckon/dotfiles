vim.pack.add({
  "https://github.com/pmizio/typescript-tools.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
})

-- NOTE: this handles all of ts_ls, meaning **DO NOT INSTALL** it manually
require("typescript-tools").setup({
  settings = {
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
    },
  },
})
