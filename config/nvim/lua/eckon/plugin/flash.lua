vim.pack.add({ "https://github.com/folke/flash.nvim" })

-- just enhance the `/`, `?`, `f` and `t` instead of using flash mappings
require("flash").setup({
  highlight = { backdrop = false },
  modes = {
    search = { enabled = true, highlight = { backdrop = false } },
    char = { enabled = true, highlight = { backdrop = false } },
  },
})
