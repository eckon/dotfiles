vim.pack.add({
  "https://github.com/saghen/blink.lib",
  "https://github.com/saghen/blink.cmp",
})

local cmp = require("blink.cmp")

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
    },
  },
  -- disable warning but still use rust if available (quickfix for bd network, as it fails to download)
  fuzzy = { implementation = "prefer_rust" },
})

-- build rust fuzzy matcher (e.g. after update) in background, lua matcher is used until restart
-- NOTE: `cargo` via `rust` is needed to let this be built
if not cmp.library_available() then
  vim.notify("blink.cmp: building fuzzy matcher, restart nvim when done")
  cmp.build():map(vim.schedule_wrap(function()
    vim.notify("blink.cmp: build done, restart nvim")
  end))
end
