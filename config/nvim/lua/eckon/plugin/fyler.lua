vim.pack.add({
  "https://github.com/A7Lavinraj/fyler.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

local fyler = require("fyler")

fyler.setup({
  close_on_select = false,
  views = {
    explorer = {
      width = 0.5,
      height = 0.5,
      kind = "split:right",
      border = "single",
    },
  },
})

require("eckon.helper.utils").bind_map("n")(
  "<Leader>ft",
  "<CMD>Fyler kind=split_right<CR>",
  { desc = "Fyler: Toggle find file tree" }
)
