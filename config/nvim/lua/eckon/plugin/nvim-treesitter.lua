vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  -- install all to also have the parser inside fenced code blocks etc.
  ensure_installed = "all",
  -- has problems installing, as its unused -> ignore
  ignore_install = { "ipkg" },
  highlight = { enable = true },
})
