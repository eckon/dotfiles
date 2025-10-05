vim.pack.add({
  "https://github.com/pmizio/typescript-tools.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
})

require("typescript-tools").setup({
  settings = {
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
    },
  },
})
