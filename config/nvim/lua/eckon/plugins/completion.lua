return {
  "saghen/blink.cmp",
  version = "*",
  config = function()
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
  end,
}
