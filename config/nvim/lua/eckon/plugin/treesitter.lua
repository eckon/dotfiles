vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  auto_install = true,
  highlight = { enable = true },
})
