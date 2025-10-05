vim.pack.add({ { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") } })

require("blink.cmp").setup({
  completion = {
    list = { selection = { auto_insert = true, preselect = false } },
    documentation = { auto_show = true },
  },
  keymap = { preset = "enter" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
})
