vim.pack.add({ {
  src = "https://github.com/saghen/blink.cmp",
  version = vim.version.range("*"),
} })

require("blink.cmp").setup({
  completion = {
    list = { selection = { auto_insert = true, preselect = false } },
    documentation = { auto_show = true },
  },
  signature = { enabled = true },
  keymap = { preset = "enter" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  -- disable warning but still use rust if available (quickfix for bd network, as it fails to download)
  fuzzy = { implementation = "prefer_rust" },
})
