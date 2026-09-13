vim.pack.add({
  "https://github.com/saghen/blink.lib",
  "https://github.com/saghen/blink.cmp",
  "https://github.com/mikavilpas/blink-ripgrep.nvim",
})

local cmp = require("blink.cmp")

-- NOTE: `cargo` via `rust` is needed to let this be built
cmp.build():pwait()

cmp.setup({
  completion = {
    list = { selection = { auto_insert = true, preselect = false } },
    documentation = { auto_show = true },
  },
  cmdline = {
    keymap = {
      -- also let tab be used to accept selection (to be similar to other editors)
      ["<Tab>"] = { "show", "accept" },
    },
    completion = { menu = { auto_show = true } },
  },
  signature = { enabled = true },
  keymap = { preset = "enter" },
  sources = {
    default = {
      "lsp",
      "path",
      -- uses built-in `vim.snippet`, gets it from `nvim/snippets/*` in format of `friendly_snippets`
      "snippets",
      "buffer",
      "ripgrep",
    },
    providers = {
      ripgrep = {
        module = "blink-ripgrep",
        name = "Ripgrep",
        ---@module "blink-ripgrep"
        ---@type blink-ripgrep.Options
        opts = {},
      },
    },
  },
  -- disable warning but still use rust if available (quickfix for bd network, as it fails to download)
  fuzzy = { implementation = "prefer_rust" },
})
