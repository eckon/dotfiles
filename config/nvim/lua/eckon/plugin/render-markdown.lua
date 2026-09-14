vim.pack.add({
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
  -- mainly completion for callouts and checkboxes
  completions = { lsp = { enabled = true } },
})
